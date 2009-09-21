# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Set constant for use in /keys and banner development benefits
BANNER    = (['development','staging'].include? ENV['RAILS_ENV'])
KEYS      = (['development','demonstration','staging'].include? ENV['RAILS_ENV'])
DEV_MODE  = BANNER

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  # config.gem 'will_paginate'
  # config.gem 'mislav-will_paginate', :version => '~>2.3', :lib => 'will_paginate', :source => 'http://gems.github.com/'
  config.gem "rmagick", :lib => "RMagick"
  config.gem "pdf-writer", :lib => "pdf/writer"
  config.gem "newrelic_rpm"

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
  #set the load paths to load unpacked gems
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_buxton_session',
    :secret      => '3bff5604e6be86fafcfb96e4fe2bf0d158bed59491b7804ff273872823de22bbf07b8640dc83aacab8409cba5a97d40ec60721522fb3c63e6c64629836864f20'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'
  
  require 'RMagick'

  # Commented out for now due to config.time_zone and the following link
  # http://b.lesseverything.com/2008/6/9/converting-tzinfo-from-rails-2-0-to-2-1
  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end

ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
  :default => '%d/%m/%Y'
)
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => '%d/%m/%Y %H:%M'
)

class String
  alias :orig_titlecase :titlecase
  def titlecase
    words = self.split(' ')
    result = []
    words.each do |word|
      if word == word.upcase
        result << word
      else
        result << word.orig_titlecase
      end
    end
    result.join(' ')
  end
end

if ActionMailer::Base.delivery_method == :smtp and ActionMailer::Base.smtp_settings.has_key?(:pop3_auth)
  class ActionMailer::Base

    alias_method :base_perform_delivery_smtp, :perform_delivery_smtp

    @@pop3_auth_done = nil

    private

    def perform_delivery_smtp(mail)
      do_pop_auth #if !@@pop3_auth_done
      base_perform_delivery_smtp(mail)
    end

    # Implementacion de la autenticacion
    def do_pop_auth
      require 'net/pop'
      pop = Net::POP3.new(smtp_settings[:pop3_auth][:server])
      pop.start(smtp_settings[:pop3_auth][:user_name], smtp_settings[:pop3_auth][:password])
      @@pop3_auth_done = Time.now  
      pop.finish
      raise "pop authed"
    end
  end
end 
