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
          :render => { :inline => 'Invalid request.' }
         
  # List the section status for the different functions of an Organisation
  # but don't paginate, a long list is actually more convenient for the Organisation
  # Manager to scan down.
  def list
    @organisation = Organisation.find(@current_user.organisation.id)
    
    case params[:id]
    when 'purpose'
      render :template => 'sections/list_purpose'
    when 'performance'
      render :template => 'sections/list_performance'
    when 'confidence_information'
      render :template => 'sections/list_confidence_information'
    when 'confidence_consultation'
      render :template => 'sections/list_confidence_consultation'
    when 'additional_work'
      render :template => 'sections/list_additional_work'
    when 'action_planning'
      render :template => 'sections/list_action_planning'
    else
      # Else render Purpose
      render :template => 'sections/list_purpose'      
    end
  end

  #
  # Show the summary information for a function's section
  # Available to both the Function and Organisation managers.
  #
  def show
    # TODO: improve this - all a bit ugly
    f_id = if (@current_user.user_type == User::TYPE[:organisational])
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
        @function_responses = @function.function_strategies.sort_by {|fr| fr.strategy.position } # sort by position
        render :template => 'sections/show_purpose'
      when 'performance'
        render :template => 'sections/show_performance'
      when 'confidence_information'
        render :template => 'sections/show_confidence_information'
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
  # These are edited by the Function manager.
  def edit
    @function = Function.find(@current_user.function.id)
    @user = @function.user
    @equality_strand = ''
    case params[:equality_strand]
    when 'overall'
      @equality_strand = 'overall'
    when 'gender'
      @equality_strand = 'gender'
    when 'race'
      @equality_strand = 'race'
    when 'sexual_orientation'
      @equality_strand = 'sexual_orientation'
    when 'disability'
      @equality_strand = 'disability'
    when 'faith'
      @equality_strand = 'faith'
    when 'age'
      @equality_strand = 'age'
    else
      # K: TODO: catch this - we shouldn't ever be here
    end

    case params[:id]
    when 'purpose'
      @function_responses = @function.function_strategies.sort_by {|fr| fr.strategy.position } # sort by position
      render :template => 'sections/edit_purpose'
    when 'performance'
      render :template => 'sections/edit_performance'
    when 'confidence_information'
      render :template => 'sections/edit_confidence_information'
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
  def update
    # Update the answers in the function table
    @function = Function.find(@current_user.function.id)
    @function.update_attributes(params[:function])
    
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