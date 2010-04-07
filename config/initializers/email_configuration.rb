# Configuration for the SMTP server.
if RAILS_ENV != 'test'
  # c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  # ActionMailer::Base.smtp_settings = {
  #   :address => c[RAILS_ENV]['address'],
  #   :port => c[RAILS_ENV]['port'],
  #   :domain => c[RAILS_ENV]['domain'],
  #   :pop3_auth => { 
  #     :server => c[RAILS_ENV]['server'], 
  #     :user_name => c[RAILS_ENV]['username'],
  #     :password => c[RAILS_ENV]['password'],
  #     :authentication => c[RAILS_ENV]['authentication']
  #   }
  # }
  
  
  # No need with gmail for the email settings. Use hack from
  # http://godbit.com/forum/viewtopic.php?id=876
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "blackradley.com",
    :authentication => :plain,
    :user_name => "support@blackradley.com",
    :password => "impact2010"
  }
end