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
  before_filter :set_banner if DEV_MODE
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from NoMethodError, :with => :wrong_user?
  
  # Consider requests made from 27stars router as local. This will enable more details error reports in-page
  # and no automatic e-mails sent out. Reducing false positives.
  consider_local "82.69.170.6"
    
protected
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
  
  # Do your best to detect invalid user type and show a better error:
  # - Act Man pages with Org Man
  # - Org Man pages with Act Man, etc.
  # This is quick and temporary until we have proper user access control when going in to production.
  def wrong_user?(exception)
    message = exception.message
    if message =~ /^undefined method `activity' for #<OrganisationManager/ then
      @hide_menu = true
      render :text => "<h3>Access Denied</h3><p>Organisation Managers cannot access Activity Manager pages.</p>", :layout => true
    elsif message =~ /^undefined method `organisation' for #<ActivityManager/ then
      @hide_menu = true      
      render :text => "<h3>Access Denied</h3><p>Activity Managers cannot access Organisation Manager pages.</p>", :layout => true
    end
    # Tested: all other NoMethodErrors are passed on and cause proper exceptions.
  end
  
  # To reduce code duplication in the controllers, we override rescue_action to catch RecordInvalid and RecordNotFound 
  # errors and handle them here instead. Admittedly we are using exceptions here for something that could be considered
  # normal code execution but Rails 2.0 will handle this nicer with rescue_from which this approach will also prep for.
  # http://api.rubyonrails.org/classes/ActionController/Rescue.html#M000086
  # Of note, only find() actually raises the RecordNotFound exception. If you want this to be handled with any
  # other queries you must throw one yourself.
  # e.g. @person = Person.find_by_name(params[:name]) or raise ActiveRecord::RecordNotFound
  # @first = Person.find(:first) or raise ActiveRecord::RecordNotFound
  # @people = Person.find(:all) or raise ActiveRecord::RecordNotFound
  # http://api.rubyonrails.com/classes/ActiveRecord/Base.html#M001005
=begin
  def rescue_action(exception)
    case exception
    when ActiveRecord::RecordInvalid
      render_invalid_record(exception.record)
    when ActiveRecord::RecordNotSaved
      render_invalid_record(exception.record)      
    when ActiveRecord::RecordNotFound
      render_not_found_record()  
    else 
      super
    end
  end

  def render_invalid_record(record)
    render :action => (record.new_record? ? 'new' : 'edit')
  end  
  
  def render_not_found_record()
    respond_to do |format|
      format.html { render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 }
    end
  end
=end
private
  # Log the user out of the system by killing the session parameter that identifies them as being logged in
  # Kill the @current_user variable as well as this is collected before any call to logout() can be made
  # resulting in a page, on that one occasion, which thinks you are logged in even after logout() is called.
  def logout
    session[:user_id] = nil
    @current_user = nil
  end  
end