# frozen_string_literal: true

module MyApplication
  module Config
    module Log
      def logger
        return @logger ||= Logger.new('/dev/null') if ENV['RACK_ENV'] == 'test'
        return @logger ||= Logger.new(STDOUT) if ENV['RACK_ENV'] == 'development'

        @logger ||= LogStashLogger.new(uri: ENV['LOGSTASH_URI'] || 'stdout:/').tap do |logger|
          logger.level = if ENV['LOG_DEBUG']
                           ::Logger::DEBUG
                         else
                           ::Logger::INFO
                         end
        end
      end
    end
  end
end
