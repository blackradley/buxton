Airbrake.configure do |config|
  config.api_key = 'cc0d82cd6352d0d1d3f7a624bdfedfb5'
  config.host    = 'errbit.27stars.co.uk'
  config.port    = 80
  config.secure  = config.port == 443
end