# Configuration to state who to send exception notifications to
ExceptionNotifier.exception_recipients = %w(karl@27stars.co.uk joe@27stars.co.uk heather@27stars.co.uk iain_wilkinson@blackradley.com)
ExceptionNotifier.sender_address = %("Application Error" <error@27stars.co.uk>)
ExceptionNotifier.email_prefix = "[#{ENV['RAILS_ENV'].upcase} ERROR] "