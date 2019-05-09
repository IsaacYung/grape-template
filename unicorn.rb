ROOT = Pathname.new(File.expand_path('../', __FILE__))
require_relative 'config/log'
extend MyApplication::Config::Log

UNICORN_PROCESSES = 4
DEFAULT_TIMEOUT = 15
DEVELOPMENT_TIMEOUT = 3000
DEFAULT_ENVIRONMENT = :development
ENVIRONMENTS = %i[production sandbox integration].freeze

env = ENV['RACK_ENV'].to_sym || DEFAULT_ENVIRONMENT

logger = logger

if env == DEFAULT_ENVIRONMENT
  timeout DEVELOPMENT_TIMEOUT

  worker_processes UNICORN_PROCESSES
end

if ENVIRONMENTS.include? env
  timeout (ENV['TIMEOUT'] || DEFAULT_TIMEOUT).to_i

  worker_processes (ENV['UNICORN_PROCESSES'] || UNICORN_PROCESSES).to_i
end

GC.respond_to?(:copy_on_write_friendly=) &&
  (GC.copy_on_write_friendly = true)

check_client_connection false

before_fork do |_server, _worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
