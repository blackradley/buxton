#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class SectionsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # TODO: reinstate this when a section can be invalidated + check it works when POSTing to itself from /update to /update
  # verify  :method => :post,
  #         :only => [ :update ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # List the section status for the different activities of an Organisation
  # but don't paginate, a long list is actually more convenient for the Organisation
  # Manager to scan down.
  # Available to: Organisation Manager
  def list
    @organisation = @current_user.organisation

    case @current_user.class.to_s
    when 'DirectorateManager'
      @directorates = [@current_user.directorate]
    when 'OrganisationManager'
      @directorates = @organisation.directorates
      @projects = @organisation.projects
    when 'ProjectManager'
      @projects = [@current_user.project]
    else
      # TODO throw an error - shouldn't ever get here
    end

    unless params[:id] then
      redirect_to :id => 'purpose'
    end

    # Validate
    @section = params[:id]
  end

  # Show the summary information for a activity's section
  # Available to: Organisation Manager
  #               Activity Manager
  def show
    # TODO: improve this - all a bit ugly
    f_id = (@current_user.class == OrganisationManager)? params[:f] : @current_user.activity.id
    @activity = Activity.find(f_id)
    # Only display the answers if Activity/Policy Existing/Proposed are answered otherwise
    # we don't know what label text to use.
   # begin
      if @activity.started then
        if params[:id] == 'purpose' then
          org_strategies = @activity.organisation.organisation_strategies
           @activity_org_strategies = Array.new(org_strategies.size) do |i|
             @activity.activity_strategies.find_or_create_by_strategy_id(org_strategies[i].id)
           end
           dir_strategies = @activity.directorate.directorate_strategies
           @activity_dir_strategies = Array.new(dir_strategies.size) do |i|
             @activity.activity_strategies.find_or_create_by_strategy_id(dir_strategies[i].id)
           end
           project_strategies = @activity.project.project_strategies
           @activity_project_strategies = Array.new(project_strategies.size) do |i|
             @activity.activity_strategies.find_or_create_by_strategy_id(project_strategies[i].id)
           end
        end
        @section = params[:id]
        render :template => 'sections/show'
      else
        render :text => 'Function/Policy not started.', :layout => true
      end
   # rescue
   #   render :inline => 'Invalid section.'
   # end
  end

  # Get the activity information ready for editing using the appropriate form.
  # Available to: Activity Manager
  def edit
    strand = params[:equality_strand]
    @activity = @current_user.activity
    @activity_manager = @activity.activity_manager

    @equality_strand = ''
    valid_equality_strands = ['overall','gender','race','sexual_orientation','disability','faith','age']
    if valid_equality_strands.include? params[:equality_strand]
      @equality_strand = params[:equality_strand]
      @id = params[:id]
    else
      # throw error
      raise RecordNotFound
    end

    case params[:id]
    when 'purpose_a'
      org_strategies = @activity.organisation.organisation_strategies
      @activity_org_strategies = Array.new(org_strategies.size) do |i|
        @activity.activity_strategies.find_or_create_by_strategy_id(org_strategies[i].id)
      end
      dir_strategies = @activity.directorate.directorate_strategies
      @activity_dir_strategies = Array.new(dir_strategies.size) do |i|
        @activity.activity_strategies.find_or_create_by_strategy_id(dir_strategies[i].id)
      end
      @projects = @activity.projects
      @activity_project_strategies = [
        @projects.map do |p|
          p.project_strategies.map do |ps|
            @activity.activity_strategies.find_or_create_by_strategy_id(ps.id)
          end
        end
      ]
      @activity_project_strategies = @activity_project_strategies.flatten
      render :template => 'sections/edit_purpose_a'
    when 'purpose_b'
      render :template => 'sections/edit_purpose_b'
    when 'purpose_c'
      render :template => 'sections/edit_purpose_c'
    when 'impact'
      @section = :impact
      render :template => 'sections/edit_impact'
    when 'consultation'
      @section = :consultation
      render :template => 'sections/edit_consultation'
    when 'additional_work'
      render :template => 'sections/edit_additional_work'
    when 'action_planning'
      @impact_enabled =  (@activity.send("impact_#{strand}_9") == 1)
      @consultation_enabled =  (@activity.send("consultation_#{strand}_7") == 1)
      render :template => 'sections/edit_action_planning'
    else
      # throw error
      raise ActiveRecord::RecordNotFound
    end
  end

  # Update the activity answers, for this particular section, as appropriate
  # Available to: Activity Manager
  def update
    # If we have issues to process
    if params[:activity][:issue_attributes] then
      #removes all blank elements from the array that were not there previously (ie those without id's)
      params[:activity][:issue_attributes].reject!{|i| i['description'].blank? && i['id'].nil? }
      #marks all previously existing issues that had their description field blanked for destruction
      params[:activity][:issue_attributes].each{|i| i['issue_destroy'] = 1 if i['description'].blank?}
    end

    # Update the answers in the activity table
    @activity = @current_user.activity
    @activity.update_attributes!(params[:activity])
    # Update the activity strategy answers if we have any (currently only in the Purpose section)
    if params[:strategy_responses] then
      params[:strategy_responses].each do |strategy_response|
        numeric_response = @activity.hashes['choices'][3].index(strategy_response[1])
        activity_strategy = @activity.activity_strategies.find_or_create_by_strategy_id(strategy_response[0])
        activity_strategy.strategy_response = numeric_response
        activity_strategy.save!
      end
    end

    flash[:notice] =  "#{@activity.name} was successfully updated."
    redirect_to :controller => 'activities', :action => 'questions'

  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] =  "Could not update the activity."
    @equality_strand = params[:equality_strand]
    @id = params[:id]

    case @id
    when 'purpose'
      strategies = @activity.organisation.organisation_strategies.sort_by(&:position) # sort by position
      @activity_strategies = Array.new(strategies.size) do |i|
        @activity.activity_strategies.find_or_create_by_strategy_id(strategies[i].id)
      end
      render :template => 'sections/edit_purpose'
    when 'impact'
      render :template => 'sections/edit_impact'
    when 'consultation'
      render :template => 'sections/edit_consultation'
    when 'additional_work'
      render :template => 'sections/edit_additional_work'
    else
      # throw error
      raise ActiveRecord::RecordNotFound
    end
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
end
