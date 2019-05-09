module MyApplication
  module Consumers
    class OtherSampleConsumer < BaseConsumer
      include MyApplication::Config::Log

      def initialize(channel, queue, consumer_tag = nil)
        super(channel, queue, consumer_tag)
        @routing_keys = ['other.sample.created'].freeze
      end

      def execute(payload, _routing_key)
        account = JSON.parse(payload, symbolize_names: true)
        logger.info "routing_key = other.sample.created"

        StatsD.increment 'other.sample.created.success'
      end
    end
  end
end
