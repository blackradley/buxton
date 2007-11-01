#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '1.2.3' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  config.frameworks -= [ :action_web_service ]

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store
  
  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile
 
# Configuration for the SMTP server.
ActionMailer::Base.smtp_settings = {
  :address  => "mail.protectedservice.net",
  :port  => 25, 
  :domain  => 'www.blackradley.com',
  :user_name  => "Iain_Wilkinson@blackradley.com",
  :password  => 'callustu',
  :authentication  => :login
}

# Configuration to state who to send exception notifications to
ExceptionNotifier.exception_recipients = %w(karl@27stars.co.uk joe@27stars.co.uk heather@27stars.co.uk)