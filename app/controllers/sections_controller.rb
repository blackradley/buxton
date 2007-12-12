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
  verify  :method => :post,
          :only => [ :update ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }
         
  # List the section status for the different activities of an Organisation
  # but don't paginate, a long list is actually more convenient for the Organisation
  # Manager to scan down.
  # Available to: Organisation Manager
  def list
    @organisation = Organisation.find(@current_user.organisation.id)
    
    case params[:id]
    when 'purpose'
      render :template => 'sections/list_purpose'
    when 'impact'
      render :template => 'sections/list_impact'
    when 'consultation'
      render :template => 'sections/list_consultation'
    when 'additional_work'
      render :template => 'sections/list_additional_work'
    when 'action_planning'
      render :template => 'sections/list_action_planning'
    else
      # Else redirect to Purpose
      redirect_to :id => 'purpose'
    end
  end

  # Show the summary information for a activity's section
  # Available to: Organisation Manager
  #               Activity Manager
  def show
    # TODO: improve this - all a bit ugly
    f_id = if (@current_user.class.name == 'OrganisationManager')
      params[:f]
    else
      @current_user.activity.id
    end
    
    @activity = Activity.find(f_id)
    
    # Only display the answers if Activity/Policy Existing/Proposed are answered otherwise
    # we don't know what label text to use.
    if @activity.started then
      case params[:id]
      when 'purpose'
        render :template => 'sections/show_purpose'
      when 'impact'
        render :template => 'sections/show_impact'
      when 'consultation'
        render :template => 'sections/show_consultation'
      when 'additional_work'
        render :template => 'sections/show_additional_work'
      when 'action_planning'
        render :template => 'sections/show_action_planning'
      else
        # K: TODO: catch this - we shouldn't ever be here
        render :inline => 'Invalid section.'
      end
    else
      render :text => 'Activity/Policy not started.', :layout => true
    end
  end

  # Get the activity information ready for editing using the appropriate form.
  # Available to: Activity Manager
  def edit
    @activity = Activity.find(@current_user.activity.id)
    @activity_manager = @activity.activity_manager
    
    @equality_strand = ''    
    valid_equality_strands = ['overall','gender','race','sexual_orientation','disability','faith','age']
    if valid_equality_strands.include? params[:equality_strand]
      @equality_strand = params[:equality_strand]
    else
      # throw error
      render :inline => 'Invalid section.'
      return
    end
    
    case params[:id]
    when 'purpose'
      @activity_responses = @activity.activity_strategies.sort_by {|fr| fr.strategy.position } # sort by position
      render :template => 'sections/edit_purpose'
    when 'impact'
      render :template => 'sections/edit_impact'
    when 'consultation'
      @issue = Issue.new
      render :template => 'sections/edit_consultation'
    when 'additional_work'
      render :template => 'sections/edit_additional_work'
    when 'action_planning'
      render :template => 'sections/edit_action_planning'
    else
      # K: TODO: catch this - we shouldn't ever be here
      render :inline => 'Invalid section.'
    end
  end

  # Update the activity answers, for this particular section, as appropriate
  # Available to: Activity Manager
  def update
    # Update the answers in the activity table
    @activity = @current_user.activity
    @activity.update_attributes!(params[:activity])
    # Since answers have changed, force recalculation of statistics
    @activity.stat_function = nil
    # Update the activity strategy answers if we have any (currently only in the Purpose section)
    if params[:activity_strategies] then
      params[:activity_strategies].each do |activity_strategy|
        activity_response = @activity.activity_strategies.find_or_create_by_strategy_id(activity_strategy[0])
        activity_response.strategy_response = activity_strategy[1]
        activity_response.save
      end
    end
    flash[:notice] =  "#{@activity.name} was successfully updated."
    redirect_to :back
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end  
end