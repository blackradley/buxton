Buxton::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.cache_classes = true

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching             = true

  TLD_LENGTH = 2

  # Use sendmail protocol to deliver emails
  config.action_mailer.delivery_method = :sendmail

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # In production, Apache or nginx will already do this
  config.serve_static_files = false

  config.i18n.fallbacks = true

  config.action_mailer.default_url_options = { :host => 'preview.impactequality.co.uk' }

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.eager_load = true
  config.log_level = :debug
end

BANNER    = true
KEYS      = true
DEV_MODE  = BANNER
