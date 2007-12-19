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
          :only => [ :destroy, :create, :update, :update_activity_type, :update_contact ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors  

  # By default, show the summary page. Not presently referenced anywhere.
  # Available to: Organisation Manager
  def index
    @activity = @current_user.activity
  end

  # These are summary statistics for all the activities within this organisation.
  # Available to: Organisation Manager
  def summary
    @organisation = @current_user.organisation
    @activities = @organisation.activities
    @results_table = @organisation.activity_summary_table
  end

  # Show the summary information for a specific activity.
  # Available to: Activity Manager
  def show
    @activity = @current_user.activity
  end

  # Shows the section matrix state for a specific activity.
  # Available to: Activity Manager
  def overview
    @activity = @current_user.activity
  end
  
  # List and provide a summary of the state of all the activities in this organisation.
  # Available to: Organisation Manager
  def list
    @organisation = @current_user.organisation
    @directorates = @organisation.directorates
  end
  
  # Create a new Activity and a new associated user, all activities must have single a valid User.
  # Available to: Organisation Manager
  def new
    @activity = Activity.new
    @activity_manager = @activity.build_activity_manager
    @directorates = @current_user.organisation.directorates.collect{ |d| [d.name, d.id] }
  end

  # Create a new activity and a new user based on the parameters in the form data.
  # Available to: Organisation Manager  
  def create
    @activity = Activity.new(params[:activity])
    @activity_manager = @activity.build_activity_manager(params[:activity_manager])
    @activity_manager.passkey = ActivityManager.generate_passkey(@activity_manager)

    Activity.transaction do
      @activity.save!
      flash[:notice] = "#{@activity.name} was created."
      redirect_to :action => :list
    end
  end

  # Update the activity details accordingly.
  # Available to: Activity Manager  
  def update
    @activity = @current_user.activity
    @activity.update_attributes!(params[:activity])
    flash[:notice] =  "#{@activity.name} was successfully updated."
    redirect_to :back
    
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :show
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def activity_type
    @activity = @current_user.activity
  end

  # Update the activity status and proceed, or not, accordingly
  # Available to: Activity Manager  
  def update_activity_type
    @activity = @current_user.activity
    @activity.update_attributes!(params[:activity])
    
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

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :activity_type
  end

  # Get both the activity and user information ready for editing, since they
  # are both edited at the same time. The organisational manager edits these
  # not the Activity manager.
  # Available to: Organisation Manager  
  def edit_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.class.name == 'OrganisationManager') then render :inline => 'Invalid.' end

    # Get the Activity and User details ready for the view
    @activity = Activity.find(params[:id])
    @activity_manager = @activity.activity_manager
    @directorates = @activity.organisation.directorates.collect{ |d| [d.name, d.id] }
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
      # @activity_manager = @activity.activity_manager
      # @activity_manager.update_attributes!(params[:activity_manager])
      flash[:notice] =  "#{@activity.name} was successfully changed."
      redirect_to :action => 'list'
    end
    # Something went wrong
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
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
  end

  # Show a printer friendly summary page
  # Available to: Activity Manager
  def print
    @activity = @current_user.activity
    
    # Set print_only true and render the normal show action, which will check this variable and include
    # the appropriate CSS as necessary.
    @print_only = true
    render :action => 'show'
  end

  def view_pdf
      @activity = @current_user.activity
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
  
  def show_errors(exception)
    flash[:notice] = 'Activity could not be updated.'    
    render :action => (exception.record.new_record? ? :new : :edit) 
  end
end