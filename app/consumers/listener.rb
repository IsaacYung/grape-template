module MyApplication
  module Consumers
    class Listener < MyApplication::Config::RabbitMQ::Queue
      def self.init
        define do
          queue name: 'other_sample_created',
                consumer: MyApplication::Consumers::OtherSampleConsumer,
                routing_key: 'other.sample.created'

          queue name: 'sample_created',
                consumer: MyApplication::Consumers::SampleConsumer,
                routing_key: 'sample.created',
                condition: true
        end
      end
    end
  end
end
