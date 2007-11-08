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
  include ExceptionNotifiable
    
  before_filter :authenticate
  before_filter :set_current_user
    
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_buxton_session_id'

protected
  # Check that the user in the session is for real.
  def authenticate
    if secure? && session[:user_id].nil?
      redirect_to :controller => 'users'
    end
  end

  # If the user_id session variable exists, grab this user from the database and store
  # in @current_user available to the action of any controller.
  def set_current_user
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
  end

  # Override in controller classes that should require authentication
  def secure?
    false
  end

private
  # Log the user out of the system by killing the session parameter that identifies them as being logged in
  def logout
    session[:user_id] = nil    
  end  
end
