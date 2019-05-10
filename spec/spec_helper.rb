# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'
Encoding.default_external = 'UTF-8'

require 'bundler/setup'
require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage')
  SimpleCov.coverage_dir(dir)
end

SimpleCov.minimum_coverage 90
SimpleCov.start do
  add_filter '/spec/'
  add_filter 'boot.rb'
  add_filter '/initializers/'

  add_group 'Api', '../app/api'
  add_group 'Helpers', '../app/helpers'
  add_group 'Verifiers', '../app/verifiers'
  add_group 'Models', '../app/models'
  add_group 'Consumers', '../app/consumers'
  add_group 'Producers', '../app/producers'
end

Bundler.require
Bundler.setup(:default, :test)

lib_path = File.expand_path(File.dirname(__FILE__) + '/../app')
$LOAD_PATH.unshift lib_path

require 'rack/test'
require 'webmock/rspec'
require 'factory_girl'
require 'bunny-mock'
require 'statsd-instrument'
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

require File.expand_path('../boot', __dir__)
require 'json_helper'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include JSONHelper
  config.include FactoryGirl::Syntax::Methods
  config.include StatsD::Instrument::Matchers

  config.fuubar_progress_bar_options = { format: 'Progress: [%c/%C] |%B| %p%% %a', progress_mark: '█' }

  config.before :suite do
    FactoryGirl.find_definitions
  end

  config.around do |example|
    ActiveRecord::Base.logger.level = Logger::INFO
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  config.before :each do
    Mongoid.purge!
  end
end

def app
  API::Base
end
