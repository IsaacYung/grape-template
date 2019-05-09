module MyApplication
  module Consumers
    class SampleConsumer < BaseConsumer
      include MyApplication::Config::Log

      def initialize(channel, queue, consumer_tag = nil)
        super(channel, queue, consumer_tag)
        @routing_keys = ['sample.created'].freeze
      end

      def execute(payload, _routing_key)
        account = JSON.parse(payload, symbolize_names: true)
        logger.info "routing_key = sample.created"

        StatsD.increment 'sample.created.success'
      end
    end
  end
end
