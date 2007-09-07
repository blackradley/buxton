class SectionsController < ApplicationController

  #
  # List the section status for the different functions of an Organisation
  # but don't paginate, a long list is actually more convenient for the Organisation
  # Manager to scan down.
  #
  def list
    @organisation = Organisation.find(params[:id])
    
    case params[:section]
    when 'purpose'
      render :template => 'sections/list_purpose'
    when 'performance'
      render :template => 'sections/list_performance'
    else
      # K: TODO: catch this - we shouldn't ever be here
      render :inline => 'Invalid section.'
    end
  end

  #
  # Show the summary information for a function's section
  # Available to both the Function and Organisation managers.
  #
  def show
    @function = Function.find(params[:id])

    case params[:section]
    when 'purpose'
      render :template => 'sections/show_purpose'
    when 'performance'
      render :template => 'sections/show_performance'
    else
      # K: TODO: catch this - we shouldn't ever be here
      render :inline => 'Invalid section.'
    end  
  end

  #
  # Get the function information ready for editing using the appropriate form.
  # These are edited by the Function manager.
  #
  def edit
    @function = Function.find(params[:id])
    @strategies = @function.organisation.strategies
    @function_responses = @function.function_strategies # could be empty
    @user = @function.user

    case params[:section]
    when 'purpose'
      render :template => 'sections/edit_purpose'
    when 'performance'
      render :template => 'sections/edit_performance'
    else
      # K: TODO: catch this - we shouldn't ever be here
      render :inline => 'Invalid section.'
    end
  end

  #
  # Update the function answers as appropriate
  # 
  # TODO: then redirect based on the type of user.
  # TODO: if the user "email" of the user has changed then the "reminded_on"
  # date should be set to null.  Because the reminder is when the user was
  # reminded so is no longer valid if it is a new user.
  # K: TODO: check the above are valid TODOs
  # K: TODO: move this to the FunctionsController?
  #
  def update
    @function = Function.find(params[:id])
    @function.update_attributes(params[:function])
    params[:function_strategies].each do |function_strategy|
      function_response = @function.function_strategies.find_or_create_by_strategy_id(function_strategy[0])
      function_response.strategy_response = function_strategy[1]
      function_response.save
    end
    flash[:notice] =  "#{@function.name} was successfully updated."
    redirect_to :back
  end
  
end