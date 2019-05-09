

OTR::ActiveRecord.configure_from_file! 'config/database.yml'
ActiveRecord::Base.logger = LogStashLogger.new(uri: ENV['LOGSTASH_URI']) if %w[sandbox production integration].include? ENV['RACK_ENV']
ActiveRecord::Base.logger.level = Logger::INFO
