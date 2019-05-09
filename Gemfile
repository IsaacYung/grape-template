source 'http://rubygems.org'

ruby '2.6.2'

gem 'actionpack'
gem 'amatch'
# gem 'bunny'
# gem 'connection_pool'
gem 'grape'
gem 'grape-roar'
gem 'logstash-logger'
gem 'mongoid'
gem 'mongoid_search'
gem 'mysql2'
# gem 'newrelic_rpm'
gem 'otr-activerecord'
gem 'rack'
gem 'rake'
# gem 'redis'
gem 'request_store'
gem 'require_all'
gem 'rest-client'
gem 'statsd-instrument'
gem 'unicorn'

group :development do
  gem 'guard-rspec', require: false
end

group :test do
  gem 'bunny-mock'
  gem 'factory_girl'
  gem 'fuubar'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'simplecov'
  gem 'webmock'
end

group :development, :test do
  gem 'pry'
end
