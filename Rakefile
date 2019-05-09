

require 'bundler/setup'
require 'rack/test'
require 'mongoid'

load 'tasks/otr-activerecord.rake'

ENV['RACK_ENV'] ||= 'test'
require File.expand_path('boot')

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
end

namespace :db do
  task :environment do
  end
end

namespace :grape do
  desc 'Print compiled grape routes'
  task :routes do
    puts "Method\tPath"
    puts "============\n\n"
    API::Base.routes.each do |route|
      puts "[#{route.options[:method]}]\t#{route.path}"
    end
  end
end

namespace :mongo do
  desc 'Create MyApplication Indexes'
  task :create_indexes do
    # Model::PublicInfo.create_indexes
  end
end
