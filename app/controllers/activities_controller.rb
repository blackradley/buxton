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
    @organisation_manager = @activity.organisation.organisation_manager
  end

  # These are summary statistics for all the activities within this organisation.
  # Available to: Organisation Manager
  def summary
    @organisation = @current_user.organisation
    @activities = @organisation.activities
    @results_table = @organisation.results_table
  end

  # Show the summary information for a specific activity.
  # Available to: Activity Manager
  def show
    @activity = @current_user.activity
    strategies = @activity.organisation.strategies.sort_by(&:position) # sort by position
    @activity_strategies = Array.new(strategies.size) do |i|
      @activity.activity_strategies.find_or_create_by_strategy_id(strategies[i].id)
    end
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
    @directorate_term = @organisation.directorate_string
    @directorates = @organisation.directorates
  end

  # Create a new Activity and a new associated user, all activities must have single a valid User.
  # Available to: Organisation Manager
  def new
    @activity = Activity.new
    @activity_manager = @activity.build_activity_manager
        
    directorates = @current_user.organisation.directorates
    @directorate_term = @current_user.organisation.directorate_string
    @directorates = directorates.collect{ |d| [d.name, d.id] }
    
    # If the params
    if params[:directorate] && directorate = directorates.find_by_id(params[:directorate]) then
      @activity.directorate = directorate
    end
  end

  # Create a new activity and a new user brequire 'pdfwriter_extensions'  ased on the parameters in the form data.
  # Available to: Organisation Manager
  def create
    @activity = Activity.new(params[:activity])
    @activity_manager = @activity.build_activity_manager(params[:activity_manager])
    @activity_manager.passkey = ActivityManager.generate_passkey(@activity_manager)
    @directorate_term = @current_user.organisation.directorate_string
    @directorates = @current_user.organisation.directorates.collect{ |d| [d.name, d.id] } # Needed for the new template incase we need to re-render it

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
    flash[:notice] = "#{@activity.name} was successfully updated."
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
      redirect_to :controller => 'activities', :action => 'activity_type'
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
    @directorate_term = @activity.organisation.directorate_string
    @directorates = @activity.organisation.directorates.collect{ |d| [d.name, d.id] }
  end

  # Update the contact email and activity name
  # Available to: Organisation Manager
  def update_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.class.name == 'OrganisationManager') then render :inline => 'Invalid.' end

    @activity = Activity.find(params[:id])
    @activity_manager = @activity.activity_manager # Get this ready in case we need to re-render the edit template
    @directorate_term = @activity.organisation.directorate_string
    @directorates = @activity.organisation.directorates.collect{ |d| [d.name, d.id] } # Get this ready in case we need to re-render the edit template

    # Update the activity
    @activity.activity_manager.attributes = params[:activity_manager]
    @activity.attributes = params[:activity]

    if @activity.valid? && @activity.activity_manager.valid? then
      @activity.activity_manager.save!
      @activity.save!
      flash[:notice] =  "#{@activity.name} was successfully changed."
      redirect_to :action => 'list'
    else
      # Something went wrong
      render :action => :edit_contact
    end
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
    send_data ActivityPDFGenerator.new(@activity).pdf.render, :disposition => 'inline',
      :filename => "#{@activity.name}.pdf",
      :type => "application/pdf"
  end

  #silent toggle method
  def toggle_strand
    @activity = @current_user.activity
    @activity.send("#{params[:strand]}_relevant=", !@activity.send("#{params[:strand]}_relevant"))
    @activity.save
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
