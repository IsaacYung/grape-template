module MyApplication
  module Producers
    class SampleProducer < BaseProducer
      include MyApplication::Config::Log

      ROUTING_KEY = 'sample.command'

      def self.send(message:)
        message_bulk do |exchange|
          exchange.publish(message, routing_key: ROUTING_KEY, persistent: true)
        end
      end
    end
  end
end
