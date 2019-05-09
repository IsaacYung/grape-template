module MyApplication
  module Config
    module RabbitMQ
      class Connection
        class << self
          include MyApplication::Config::Log

          POOL_CONFIG = {
            size: ENV['RABBITMQ_POOL_SIZE'].to_i,
            timeout: ENV['RABBITMQ_POOL_TIMEOUT'].to_i
          }

          def create
            @pool = ConnectionPool.new(POOL_CONFIG) do
              logger.debug "rabbit connect in #{ENV['RABBITMQ_HOST']}:#{ENV['RABBITMQ_PORT']}"
              conn = Bunny.new(
                host: ENV['RABBITMQ_HOST'],
                port: ENV['RABBITMQ_PORT'],
                user: ENV['RABBITMQ_USER'],
                pass: ENV['RABBITMQ_PASS'],
                logger: logger
              )

              conn.start
            end

            @pool
          end

          def shutdown
            @pool.shutdown(&:close)
          end

          def pool
            raise ArgumentError, 'missing a block' unless block_given?
            rabbit_pool.with do |conn|
              yield conn
            end
          end

          def reset_connection_pool
            @@connection_pool = nil
          end

          private
          def rabbit_pool
            @@connection_pool ||= create
          end
        end
      end
    end
  end
end
