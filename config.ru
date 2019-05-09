

require File.expand_path('../boot', __FILE__)

$LOAD_PATH.unshift File.expand_path '..', __FILE__

# require 'newrelic_rpm'
# require 'new_relic/rack/agent_hooks'
# require 'new_relic/rack/browser_monitoring'
# require 'new_relic/rack/error_collector'
# require 'raven'

# if ENV['RACK_ENV'] == 'development'
#   puts 'Loading NewRelic in developer mode ...'
#   require 'new_relic/rack/developer_mode'
#   use NewRelic::Rack::DeveloperMode
# end

if %w[sandbox production].include? ENV['RACK_ENV']
  # NewRelic::Agent.manual_start

  Raven.configure do |config|
    config.environments = ENV['RACK_ENV']
    config.dsn = "https://#{ENV['SENTRY_PUBLIC']}:#{ENV['SENTRY_SECRET']}@app.getsentry.com/#{ENV['SENTRY_APP_ID']}"
  end
end

MyApplication::Consumers::Listener.init
MyApplication::Config::RabbitMQ::Queue.config

run API::Base
