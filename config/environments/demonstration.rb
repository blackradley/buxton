#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# Settings specified here will take precedence over those in config/environment.rb

# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_view.debug_rjs                         = false
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Don't send emails
config.action_mailer.perform_deliveries = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# We shouldn't have a TLD as we'll be running on localhost
TLD_LENGTH = 0