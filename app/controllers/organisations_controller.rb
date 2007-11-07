#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class OrganisationsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  # List the organisation for the administrative User.
  def list
    @organisation_pages, @organisations = paginate :organisations, :per_page => 10
  end

  # Show a view of an individual Organisation
  def show
    @organisation = Organisation.find(params[:id])
    @user = @organisation.user
  end

  # Create a new Organisation and a new associated User
  def new
    @organisation = Organisation.new
    @user = User.new
  end

  # Create a new organisation and a new user based on the parameters on the form.
  def create
    @organisation = Organisation.new(params[:organisation])
    @user = @organisation.build_user(params[:user])
    @user.user_type = User::TYPE[:organisational]
    @user.passkey = User.generate_passkey(@user)

    begin
      Organisation.transaction do
        @organisation.save!
        flash[:notice] = "#{@organisation.name} was created."
        redirect_to :action => :list
      end
    rescue
      render :action => 'new'
    end
  end

  # Get both the organisation and it's user since the user can also be edited
  # by the administrator.
  def edit_contact
    @organisation = Organisation.find(params[:id])
    @user = @organisation.user
  end

  def edit_strategies_description
    @organisation = Organisation.find(params[:id])
  end

  def edit_impact_groups_description
    @organisation = Organisation.find(params[:id])
  end

  def edit_equality_groups_description
    @organisation = Organisation.find(params[:id])
  end

  # Update the organisation and all of its attributes
  def update
    @organisation = Organisation.find(params[:id])
    @organisation.update_attributes(params[:organisation])
    Organisation.transaction do
      @user = @organisation.user
      @user.update_attributes(params[:user])
      flash[:notice] =  "#{@organisation.name} was successfully changed."
      redirect_to :action => 'show', :id => @organisation
    end
    rescue ActiveRecord::RecordInvalid => e
      @user.valid? # force checking of errors even if function failed
      render :action => :new
  end
  
  # Destroy the organisation
  def destroy
    @organisation = Organisation.find(params[:id])
    @organisation.destroy

    flash[:notice] = 'Organisation successfully deleted.'
    redirect_to :action => 'list'
  rescue ActiveRecord::RecordNotFound => e  
    render :inline => 'Invalid ID.'    
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
    #["list", "add", "show"].include?(action_name)
  end
end