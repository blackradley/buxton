#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class ActivitiesController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :destroy, :create, :update, :update_status, :update_contact ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # By default, show the summary page. Not presently referenced anywhere.
  # Available to: Organisation Manager
  def index
    @activity = Activity.find(@current_user.activity.id)
  end

  # These are summary statistics for all the activities within this organisation.
  # Available to: Organisation Manager
  def summary
    @organisation = Organisation.find(@current_user.organisation.id)
    @activities = @organisation.activities
    @results_table = @organisation.activity_summary_table
    
  end

  # Show the summary information for a specific activity.
  # Available to: Activity Manager
  def show
    @activity = Activity.find(@current_user.activity.id)
  end

  # Shows the section matrix state for a specific activity.
  # Available to: Activity Manager
  def overview
    @activity = Activity.find(@current_user.activity.id)
  end
  
  # List and provide a summary of the state of all the activities in this organisation.
  # Available to: Organisation Manager
  def list
    @organisation = Organisation.find(@current_user.organisation.id)
    @directorates = @organisation.directorates
  end
  
  # Create a new Activity and a new associated user, all activities must have single a valid User.
  # Available to: Organisation Manager
  def new
    @activity = Activity.new
    @function_manager = @activity.build_function_manager
    @directorates = @current_user.organisation.directorates
  end

  # Create a new activity and a new user based on the parameters in the form data.
  # Available to: Organisation Manager  
  def create
    @directorate = Directorate.find(params[:directorate][:directorate_id])
    org_id = @directorate.organisation.id
    @activity = @directorate.activities.build(params[:activity].merge(:organisation_id => org_id))
    @function_manager = @activity.build_function_manager(params[:function_manager])
    @function_manager.passkey = FunctionManager.generate_passkey(@function_manager)

    begin
      Activity.transaction do
        @activity.save!
        flash[:notice] = "#{@activity.name} was created."
        redirect_to :action => :list
      end
    rescue ActiveRecord::RecordNotSaved
        flash[:notice] = "Activity creation failed. Please try again, and if it continues to fail, contact an administrator."
        render :action => :new    
    end
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager  
  def update
    @activity = Activity.find(@current_user.activity.id)
    @activity.update_attributes!(:approved_on => Time.now) if params[:approved] = 1
    @activity.update_attributes!(params[:activity])
    puts @activity.approved_on
    flash[:notice] =  "#{@activity.name} was successfully updated."
    redirect_to :back
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def activity_type
    @activity = Activity.find(@current_user.activity.id)
  end

  # Update the activity status and proceed, or not, accordingly
  # Available to: Activity Manager  
  def update_activity_type
    @activity = Activity.find(@current_user.activity.id)
    @activity.update_attributes(params[:activity])
    
    # Check both the Activity/Policy and Existing/Proposed questions have been answered
    if @activity.started then
      # If so, proceed
      flash[:notice] =  "#{@activity.name} status was successfully set up."
      redirect_to :action => 'show'
    else
      # If not, take them back and give them a chance to answer again
      flash[:notice] =  "Please answer both questions before proceeding."
      redirect_to :action => 'activity_type'
    end
  end

  # Get both the activity and user information ready for editing, since they
  # are both edited at the same time. The organisational manager edits these
  # not the functional manager.
  # Available to: Organisation Manager  
  def edit_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.class.name == 'OrganisationManager') then render :inline => 'Invalid.' end

    # Get the Activity and User details ready for the view
    @activity = Activity.find(params[:id])
    @function_manager = @activity.function_manager    
  end

  # Update the contact email and activity name
  # Available to: Organisation Manager  
  def update_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.class.name == 'OrganisationManager') then render :inline => 'Invalid.' end

    # Update the activity
    Activity.transaction do
      @activity = Activity.find(params[:id])
      @activity.update_attributes!(params[:activity])
      # # Update the user
      # @function_manager = @activity.function_manager
      # @function_manager.update_attributes!(params[:function_manager])
      flash[:notice] =  "#{@activity.name} was successfully changed."
      redirect_to :action => 'list'
    end
    # Something went wrong
    rescue ActiveRecord::RecordInvalid || ActiveRecord::RecordNotSaved
      render :action => :edit_contact
  end

  # Delete the activity (and any associated records as stated in the Activity model)
  # Available to: Organisation Manager
  def destroy
    # Only allow an organisation manager to proceed    
    # TODO: catch this better
    unless (@current_user.class.name == 'OrganisationManager') then render :inline => 'Invalid.' end
    
    # Destroy the activity and go back to the list of activities for this organisation
    @activity = Activity.find(params[:id])
    @activity.destroy

    flash[:notice] = 'Activity successfully deleted.'
    redirect_to :action => 'list'
  rescue ActiveRecord::RecordNotFound  
    render :inline => 'Invalid ID.'    
  end

  # Show a printer friendly summary page
  # Available to: Activity Manager
  def print
    @activity = Activity.find(@current_user.activity.id)
    
    # Set print_only true and render the normal show action, which will check this variable and include
    # the appropriate CSS as necessary.
    @print_only = true
    render :action => 'show'
  end

  def view_pdf
    load "#{RAILS_ROOT}/lib/pdf_writer_extensions.rb"
    @activity = Activity.find(@current_user.activity.id)
    send_data  ActivityPDFRenderer.render_pdf(:data => @activity.generate_pdf_data),
      :type         => "application/pdf",
      :disposition  => "inline",
      :filename     => "report.pdf" 
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
end