# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# Filters added to this controller apply to all controllers in the application. 
# So it is at this point we apply the security (:authenticate) filter.
# 
require 'digest/sha1'

class ApplicationController < ActionController::Base
  before_filter :authenticate
    
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_buxton_session_id'

  protected
  # Override in controller classes that should require authentication
  def secure?
    false
  end

  private
  # Check that the user in the session is for real.
  def authenticate
    if secure? && session[:logged_in_user].nil?
      redirect_to :controller => 'users'
    end
  end
end
