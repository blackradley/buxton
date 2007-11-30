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
         
  # List the section status for the different functions of an Organisation
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
    when 'confidence_consultation'
      render :template => 'sections/list_confidence_consultation'
    when 'additional_work'
      render :template => 'sections/list_additional_work'
    when 'action_planning'
      render :template => 'sections/list_action_planning'
    else
      # Else redirect to Purpose
      redirect_to :id => 'purpose'
    end
  end

  # Show the summary information for a function's section
  # Available to: Organisation Manager
  #               Function Manager
  def show
    # TODO: improve this - all a bit ugly
    f_id = if (@current_user.class.name == 'OrganisationManager')
      params[:f]
    else
      @current_user.function.id
    end
    
    @function = Function.find(f_id)
    
    # Only display the answers if Function/Policy Existing/Proposed are answered otherwise
    # we don't know what label text to use.
    if @function.started then
      case params[:id]
      when 'purpose'
        render :template => 'sections/show_purpose'
      when 'impact'
        render :template => 'sections/show_impact'
      when 'confidence_consultation'
        render :template => 'sections/show_confidence_consultation'
      when 'additional_work'
        render :template => 'sections/show_additional_work'
      when 'action_planning'
        render :template => 'sections/show_action_planning'
      else
        # K: TODO: catch this - we shouldn't ever be here
        render :inline => 'Invalid section.'
      end
    else
      render :text => 'Function/Policy not started.', :layout => true
    end
  end

  # Get the function information ready for editing using the appropriate form.
  # Available to: Function Manager
  def edit
    @function = Function.find(@current_user.function.id)
    @function_manager = @function.function_manager
    
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
      @function_responses = @function.function_strategies.sort_by {|fr| fr.strategy.position } # sort by position
      render :template => 'sections/edit_purpose'
    when 'impact'
      render :template => 'sections/edit_impact'
    when 'confidence_consultation'
      @issue = Issue.new
      render :template => 'sections/edit_confidence_consultation'
    when 'additional_work'
      render :template => 'sections/edit_additional_work'
    when 'action_planning'
      render :template => 'sections/edit_action_planning'
    else
      # K: TODO: catch this - we shouldn't ever be here
      render :inline => 'Invalid section.'
    end
  end

  # Update the function answers, for this particular section, as appropriate
  # Available to: Function Manager
  def update
    # Update the answers in the function table
    @function = Function.find(@current_user.function.id)
    @function.update_attributes!(params[:function])
    
    # Update the function strategy answers if we have any (currently only in the Purpose section)
    if params[:function_strategies] then
      params[:function_strategies].each do |function_strategy|
        function_response = @function.function_strategies.find_or_create_by_strategy_id(function_strategy[0])
        function_response.strategy_response = function_strategy[1]
        function_response.save
      end
    end
    flash[:notice] =  "#{@function.name} was successfully updated."
    redirect_to :back
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end  
end