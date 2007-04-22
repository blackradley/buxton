#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
class OrganisationController < ApplicationController
  layout 'application'
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @organisation_pages, @organisations = paginate :organisations, :per_page => 10
  end

  def show
    @organisation = Organisation.find(params[:id])
    @user = @organisation.user
  end
#
# Create a new organisation and a new associated user
#
  def new
    @organisation = Organisation.new
    @user = User.new 
  end
#
# Create a new organiation and a new user based on the parameters on the form.  
#
  def create
    @organisation = Organisation.new(params[:organisation])
    @user = User.new(params[:user])
    @user.passkey = User.new_passkey
    @user.user_type = User::ORGANISATIONAL
    Organisation.transaction do
      @user.organisation = @organisation
      @organisation.save!
      @user.save!
      flash[:notice] = @organisation.name + ' was created.'
      redirect_to :action => :list
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new    
  end
#
# Get both the organisation and it's user since the user can also be edited
# by the administrator.
#
  def edit_contact
    @organisation = Organisation.find(params[:id])
    @user = @organisation.user
  end
#
#  
#  
  def edit_strategy_description
    @organisation = Organisation.find(params[:id])
  end
#
# Update the organiation and all of its attributes
# 
  def update
    @organisation = Organisation.find(params[:id])
    @organisation.update_attributes(params[:organisation])
    Organisation.transaction do
      @user = @organisation.user
      @user.update_attributes(params[:user])
      flash[:notice] =  @organisation.name + ' was successfully changed.'
      redirect_to :action => 'show', :id => @organisation
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new     
  end
#
# Send a reminder to the email associated with that organisation. 
#
  def remind
    @user = User.find(params[:id])
    @user.passkey = User.new_passkey
    @user.reminded_on = Time.now
    @user.save
    email = Notifier.create_organisation_key(@user, request)
    Notifier.deliver(email)
    flash[:notice] = 'Reminder for ' + @user.organisation.name + ' sent to ' + @user.email
    redirect_to :action => 'list'
  end
#
# TODO: Mark the organisation record with a deleted date
#
  def destroy
    Organisation.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
protected
#
# Secure the relevant methods in the controller.
#
  def secure?
    true
    #["list", "add", "show"].include?(action_name)
  end
end

