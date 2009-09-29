# Configuration for the SMTP server.
if RAILS_ENV != 'test'
  c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  ActionMailer::Base.smtp_settings = {
    :address => c[RAILS_ENV]['address'],
    :port => c[RAILS_ENV]['port'],
    :domain => c[RAILS_ENV]['domain']
    :pop3_auth => { 
      :server => c[RAILS_ENV]['server'], 
      :user_name => c[RAILS_ENV]['username'],
      :password => c[RAILS_ENV]['password'],
      :authentication => c[RAILS_ENV]['authentication']
    }
  }
end