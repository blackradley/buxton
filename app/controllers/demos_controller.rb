# 
# $URL$ 
# $Author$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.  
# 
class DemosController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :create ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Available to: anybody
  def new
  end

  # Create a new user and organisation, then log the user in.  Obviously this
  # bypasses the minimal security, but it is just a demo.  If the user is already
  # an organisational user the they go straight to the login.  So we don't get
  # multiple demo organisations for the same user.
  #
  # If an admin user requests a demo then one is created for them since the
  # admin users are not sought in the first find.
  # 
  # Available to: anybody
  def create
    email = params[:organisation_manager][:email]
    organisation_manager = OrganisationManager.find(:first, :conditions => { :email => email })
    
    if organisation_manager.nil? then
      # This email is not already used by an org man, create a new demo, and return the passkey
      demo = Demo.new(email)
      demo.save!
      passkey = demo.passkey
    else
      # This email has been used before, just log in as it
      passkey = organisation_manager.passkey
    end
    
    flash[:notice] = 'Demonstration organisation was created.'
    # If we made it here then all of the above was successful.
    # Log in as the organisational manager (be they new or old).
    redirect_to :controller => 'users', :action => :login, :passkey => passkey
  end

protected

  def show_errors(exception)
    flash[:notice] = "Unable to create demo. Please check for errors and try again."
    render :action => :new
  end

end