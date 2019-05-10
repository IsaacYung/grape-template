# frozen_string_literal: true

module MyApplication
  module Consumers
    class BaseConsumer < Bunny::Consumer
      include MyApplication::Config::Log

      def handle?(routing_key)
        return false if routing_key.nil?

        @routing_keys.each do |key|
          if key == routing_key
            logger.info "sorting_hat_handle_with #{consumer_tag}"
            return true
          end
        end
        false
      end

      def cancelled?
        @cancelled
      end

      def handle_cancellation(args)
        logger.info "sorting_hat_handle_cancellation #{args}"
        @cancelled = true
      end
    end
  end
end
