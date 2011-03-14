# Configuration for the SMTP server.
  
# No need with gmail for the email settings. Use hack from
  # http://godbit.com/forum/viewtopic.php?id=876

if Rails.env ==  'production'
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