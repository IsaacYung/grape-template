require 'bundler'
require 'rack'
require 'bundler/setup'
require 'rubygems'
require 'require_all'
require 'grape'
require 'json'
require 'otr-activerecord'
require 'active_record'
require 'rack/test'
require 'action_controller/metal/strong_parameters'
require 'logstash-logger'
require 'roar/representer'
require 'roar/json'
require 'roar/json/hal'
require 'amatch'
# require 'bunny'
# require 'connection_pool'

Bundler.require
Bundler.require(:default, ENV['RACK_ENV'] || :development)

ROOT = Pathname.new(File.expand_path('../', __FILE__))

require_all 'initializers'
require_all 'config'
require_all 'app'

RestClient.log = 'stdout' if 'development' == ENV['RACK_ENV']
