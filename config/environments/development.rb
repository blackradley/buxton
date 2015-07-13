Buxton::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log
  config.action_mailer.delivery_method = :sendmail
  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_controller.session = {
    :expire_after    => 14 * 24 * 3600, #Cookies will expire after 2 weeks
    :secure => true #The session will now not be sent or received on HTTP requests.
  }
end
BANNER    = true
KEYS      = true
DEV_MODE  = BANNER
TLD_LENGTH = 0

Mailsafe.setup do |config|
  # config.allowed_domain = "27stars.co.uk"
  config.override_receiver = `git config user.email`.strip
  config.prefix_email_subject_with_rails_env = true
end
