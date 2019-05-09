module MyApplication
  module Producers
    class BaseProducer
      include MyApplication::Config::Log
      include MyApplication::Config::RabbitMQ

      def self.message_bulk(&publish)
        Connection.pool do |conn|
          channel = conn.create_channel
          exchange = channel.topic('my_application', durable: true)
          publish.call(exchange) if block_given?
          channel.close
        end
      end
    end
  end
end
