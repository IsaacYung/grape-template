module MyApplication
  module Config
    module RabbitMQ
      class Queue
        class << self
          include MyApplication::Config::Log

          @@queues = []

          def config
            config = {
              topic:  'my_application',
              queues: @@queues
            }

            logger.info 'Starting RabbitMQ Consumer'
            MyApplication::Config::RabbitMQ::Connection.pool do |conn|
              channel = conn.create_channel
              channel.on_uncaught_exception do |exception, consumer|
                logger.error "ERROR on consumer [#{consumer.consumer_tag}]: #{exception}"
                logger.error exception.backtrace.join("\n\t").to_s
                Raven.capture_exception(exception)
              end

              config_queues(channel, config)
            end
          end

          def define(&queues_definition)
            yield queues_definition
          end

          def queues
            @@queues
          end

          def queue(name:, consumer:, routing_key:, condition: true)
            @@queues << {
              name: name,
              consumers: [consumer].freeze,
              routing_key: routing_key
            } if condition
          end

          private
          def config_queues(channel, config)
            topic = channel.topic config[:topic], durable: true

            config[:queues].each do |queue_conf|
              queue = channel.queue(queue_conf[:name], durable: true).bind(topic, routing_key: queue_conf[:routing_key])

              queue_conf[:consumers].each do |consumer_class|
                consumer = consumer_class.new(channel, queue)
                consumer.consumer_tag = "#{queue_conf[:name]}-#{consumer.class}"
                logger.info "Registering consumer #{consumer.consumer_tag}"

                consumer.on_delivery do |delivery_info, metadata, payload|
                  RequestStore.store[:request_id] = SecureRandom.uuid
                  logger.debug "onmessage delivery_info: #{delivery_info.inspect}, metadata: #{metadata} and paylod: #{payload}"
                  consumer.execute payload, delivery_info[:routing_key] if consumer.handle?(delivery_info[:routing_key])
                end

                queue.subscribe_with(consumer)
                logger.info "Registered consumer #{consumer.consumer_tag}"
              end

              logger.info "Registered queue #{queue_conf[:name]}"
            end
          end
        end
      end
    end
  end
end
