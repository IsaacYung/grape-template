

LogStashLogger.configure do |config|
  config.customize_event do |event|
    event['application'] = 'MyApplication'
    event['environment'] = ENV['RACK_ENV']
    event['request_id'] = RequestStore.store[:request_id]
  end
end
