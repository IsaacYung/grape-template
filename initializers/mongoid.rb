

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)
Mongoid.raise_not_found_error = false
