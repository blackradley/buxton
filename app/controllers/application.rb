# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
# Filters added to this controller apply to all controllers in the application. 
# So it is at this point we apply the security (:authenticate) filter.
# 
require 'digest/sha1'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include ExceptionNotifiable
    
  before_filter :authenticate
  before_filter :set_current_user
  before_filter :set_banner if BANNER
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from NoMethodError, :with => :wrong_user? unless DEV_MODE
  
  # Consider requests made from 27stars router as local. This will enable more details error reports in-page
  # and no automatic e-mails sent out. Reducing false positives.
  consider_local "82.69.170.6"
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => '370c47b86a8ff547b2b472693b0980a4'  
    
protected
  def log_event(type, text)
    # If this is a secret login, disable the creating of logs by returning false here
    return false if session[:secret]
    # e.g. Convert :PDF to PDFLog
    class_name = "#{type}Log"
    # Log this type of event
    # CAUTION! See: http://notetoself.vrensk.com/2008/08/escaping-single-quotes-in-ruby-harder-than-expected/
    # for why we're escaping this this way
    escaped_text = text.gsub(/\\|'/) { |c| "\\#{c}" }
    instance_eval("#{class_name}.create(:message => '#{escaped_text}')")
  end

  # Check that the user in the session is for real.
  def authenticate
    if secure? && session[:user_id].nil?
      redirect_to :controller => 'users'
    end
  end

  # If the user_id session variable exists, grab this user from the database and store
  # in @current_user making it available to the action of any controller.
  def set_current_user
    @current_user = nil
    @current_user = User.find(session[:user_id]) unless session[:user_id].nil?
  end
  
  def set_banner
    @banner_text = "Not live. You are on a server in #{RAILS_ENV} mode."

    revision_file = File.join(RAILS_ROOT, 'REVISION')
    if File.exists?(revision_file) then
      f = File.new(revision_file)
      @banner_text += " Revision: #{f.readline}."
    end
  end

  # Override in controller classes that should require authentication
  def secure?
    false
  end
  
  def not_found
    render :file => "#{RAILS_ROOT}/public/404.html",  :status => "404 Not Found"
  end
  
  # Do your best to detect invalid user type and show a better error.
  # This is quick and temporary until we have proper user access control when going in to production.
  def wrong_user?(exception)
    render :text => "<h3>Access Denied</h3><p>You do not have sufficient privileges.</p>", :layout => true
  end
  
private
  # Log the user out of the system by killing the session parameter that identifies them as being logged in
  # Kill the @current_user variable as well as this is collected before any call to logout() can be made
  # resulting in a page, on that one occasion, which thinks you are logged in even after logout() is called.
  def logout
    session[:user_id] = nil
    @current_user = nil
  end  
end