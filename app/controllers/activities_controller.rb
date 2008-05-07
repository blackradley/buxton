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
          :only => [ :destroy, :create, :update, :update_activity_type, :update_contact, :update_ces ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string

  # By default, show the summary page. Not presently referenced anywhere.
  # Available to: Organisation Manager
  def index
    @activity = @current_user.activity
    @organisation = @current_user.activity.organisation
    @organisation_managers = @activity.organisation.organisation_managers
  end

  # These are summary statistics for all the activities within this organisation.
  # Available to: Organisation Manager
  def summary
    case @current_user.class.to_s
    when 'DirectorateManager'
      @organisation = @current_user.directorate.organisation
      @activities = @current_user.directorate.activities
      @started = @activities.select{|a| a.started }.size
      @completed = @activities.select{|a| a.completed }.size
    when 'OrganisationManager'
      @organisation = @current_user.organisation
      @activities = @organisation.activities
      @started = @activities.select{|a| a.started }.size
      @completed = @activities.select{|a| a.completed }.size
    else
      # TODO throw an error - shouldn't ever get here
    end
    
    @results_table = @organisation.results_table
  end
  
  # Show the summary information for a specific activity.
  # Available to: Activity Manager
  def show
    @activity = Activity.find(@current_user.activity_id, :include => 'questions')

    strategies = @activity.organisation.strategies.sort_by(&:position) # sort by position
    @activity_strategies = Array.new(strategies.size) do |i|
      @activity.activity_strategies.find_or_create_by_strategy_id(strategies[i].id)
    end
    @relevant_strands_string = @activity.relevant_strands.map!{|s| s.titleize}.join(', ')
  end

  # List and provide a summary of the state of all the activities in this organisation.
  # Available to: Organisation Manager
  def list
    case @current_user.class.to_s
    when 'DirectorateManager'
      @organisation = @current_user.directorate.organisation
      @directorates = [@current_user.directorate]
    when 'OrganisationManager'
      @organisation = @current_user.organisation
      @directorates = @organisation.directorates
    else
      # TODO throw an error - shouldn't ever get here
    end
    @directorate_term = @organisation.directorate_string
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

  # Create a new activity and a new user based on the parameters in the form data.
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
    redirect_to :controller => 'activities', :action => 'show'

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :show
  end

  def update_ces
    @activity = @current_user.activity
    puts params[:activity][:ces_question].to_i
    @activity.update_attributes('ces_question' => params[:activity][:ces_question].to_i)
    puts "updated"
    flash[:notice] = "#{@activity.name} was successfully updated."
    #redirects not answered yet on first page to index so it can't hop past
    redirect = (params[:activity][:ces_question].to_i > 0)? 'questions' : 'index'
    redirect_to :controller => 'activities', :action => redirect

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :index
  end

  # Opening page where they must choose between Activity/Policy and Existing/Proposed
  # Available to: Activity Manager
  def questions
    @activity = @current_user.activity
    completed_status_array = @activity.strands(true).map{|strand| [strand.to_sym, @activity.completed(nil, strand)]}
    completed_status_hash = Hash[*completed_status_array.flatten]
    tag_test = completed_status_hash.select{|k,v| !v}.map(&:first).map do |strand_status|
      "($('#{strand_status.to_s}_checkbox').checked)"
    end
    @tag_test = "(#{tag_test.join('||')})"
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
    else
      # If not, take them back and give them a chance to answer again
      flash[:notice] =  "Please answer both questions before proceeding."
    end

    redirect_to :action => 'questions'

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    render :action => :questions
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

  def view_pdf
    if @current_user.class != ActivityManager then
      @activity = Activity.find(params[:id])
    else
      @activity = @current_user.activity
    end
    @activity = Activity.find(126)
    PDFLog.create(:message => %Q[The activity manager PDF for the <strong>#{@activity.name}</strong> activity, within <strong>#{@activity.organisation.name}</strong>, was viewed.])
    send_data ActivityPDFGenerator.new(@activity).pdf.render, :disposition => 'inline',
      :filename => "#{@activity.name}.pdf",
      :type => "application/pdf"
  end

  def toggle_strand
    @activity = @current_user.activity
    @activity.toggle("#{params[:strand]}_relevant")
    @activity.save!
    render :nothing => true
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
