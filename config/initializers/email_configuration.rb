# Configuration for the SMTP server.
if Rails.env != 'test'
  # c = YAML::load(File.open("#{RAILS_ROOT}/config/email.yml"))
  # ActionMailer::Base.smtp_settings = {
  #   :address => c[Rails.env]['address'],
  #   :port => c[Rails.env]['port'],
  #   :domain => c[Rails.env]['domain'],
  #   :pop3_auth => { 
  #     :server => c[Rails.env]['server'], 
  #     :user_name => c[Rails.env]['username'],
  #     :password => c[Rails.env]['password'],
  #     :authentication => c[Rails.env]['authentication']
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