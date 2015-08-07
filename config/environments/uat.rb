Buxton::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb
  config.cache_classes = true

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local = false
  config.action_controller.perform_caching             = true

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host                  = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')

  # We presently run on a .org.uk domain
  TLD_LENGTH = 2

  # Use sendmail protocol to deliver emails
  config.action_mailer.delivery_method = :sendmail

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # In production, Apache or nginx will already do this
  config.serve_static_files = false

  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'impact-equality-uat.27stars.co.uk' }

  # Set cookies to be secure
  config.action_controller.session = {
    :expire_after    => 14 * 24 * 3600, #Cookies will expire after 2 weeks
    :secure => true #The session will now not be sent or received on HTTP requests.
  }

  # Compress JavaScripts and CSS
  config.assets.js_compressor = :uglifier

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( ie_fixes/fixes_ie6.css ie_fixes/fixes_ie7.css )

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  config.eager_load = true

  config.log_level = :info
end

BANNER    = false
KEYS      = false
DEV_MODE  = BANNER
