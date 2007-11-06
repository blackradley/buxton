#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class FunctionsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :update_status, :update_contact ],
         :redirect_to => { :action => :list }

  # By default, show the summary page.
  def index
    summary
    render :action => 'summary'
  end

  # Shown to the Organisation manager, these are summary statistics for all the functions
  # within this organisation.
  def summary
    @organisation = Organisation.find(@current_user.organisation.id)
    @functions = @organisation.functions

    @results_table = { 1 => { :high => 0, :medium => 0, :low => 0 },
                      2 => { :high => 0, :medium => 0, :low => 0 }, 
                      3 => { :high => 0, :medium => 0, :low => 0 }, 
                      4 => { :high => 0, :medium => 0, :low => 0 }, 
                      5 => { :high => 0, :medium => 0, :low => 0 } }

    # Loop through all the functions this organisation has, generate statistics for
    # the completed ones and fill in the results table accordingly.
    for function in @functions
      if function.completed then
        stats = function.statistics
        @results_table[stats.fun_priority_ranking][stats.impact] += 1
      end
    end
  end

  # Available to the Function manager. Show the summary information for a specific function.
  def show
    @function = Function.find(session[@current_user.function.id].function.id)
  end

  # Available to the Function manager. Shows the section matrix state for a specific function.
  def overview
    @function = Function.find(@current_user.function.id)
  end
  
  # List and provide a summary of the state of all the functions in this organisation.
  def list
    @organisation = Organisation.find(@current_user.organisation.id)
  end
  
  # Create a new Function and a new associated user, all functions must have single a valid User.
  def new
    @function = Function.new
    @user = User.new
  end

  # Create a new function and a new user based on the parameters on the form.
  def create
    # Use transactions to ensure if one action on a model fails, they all do.
    Function.transaction do
      User.transaction do
        # Create the user
        @user = User.new(params[:user])
        @user.user_type = User::TYPE[:functional]
        @user.passkey = User.generate_passkey(@user)
        @user.save!
        # Create the function and associate the user with it
        @function = Function.new(params[:function])
        @function.organisation_id = @current_user.organisation.id
        @function.user = @user
        @function.save!
        # Go back and list all of the functions in this organisation (now including this one)
        flash[:notice] = @function.name + ' was created.'
        redirect_to :action => :list
      end
    end
    # Something went wrong
    rescue ActiveRecord::RecordInvalid => e
      @user.valid? # force checking of errors even if function failed
      render :action => :new
  end

  # Update the function details accordingly.
  def update
    @function = Function.find(@current_user.function.id)
    @function.update_attributes(params[:function])

    flash[:notice] =  "#{@function.name} was successfully updated."
    redirect_to :back
  end

  # Update the function status and proceed, or not, accordingly
  def update_status
    @function = Function.find(@current_user.function.id)
    @function.update_attributes(params[:function])
    
    # Check both the Function/Policy and Existing/Proposed questions have been answered
    if @function.purpose_overall_1 != 0 && @function.function_policy != 0 then
      # If so, proceed
      flash[:notice] =  "#{@function.name} status was successfully set up."
      redirect_to :action => 'show'
    else
      # If not, take them back and give them a chance to answer again
      flash[:notice] =  "Please answer both questions before proceeding."
      redirect_to :action => 'status'
    end
  end

  # Get both the function and user information ready for editing, since they
  # are both edited at the same time. The organisational manager edits these
  # not the functional manager.
  def edit_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end

    # Get the Function and User details ready for the view
    @function = Function.find(params[:id])
    @user = @function.user    
  end

  # Update the contact email and function name
  def update_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end

    # Update the function
    Function.transaction do
      User.transaction do
        @function = Function.find(params[:id])
        @function.update_attributes(params[:function])
        # Update the user
        @user = @function.user
        @user.update_attributes(params[:user])
        flash[:notice] =  @function.name + ' was successfully changed.'
        redirect_to :action => 'list'
      end
    end
    # Something went wrong
    rescue ActiveRecord::RecordInvalid => e
      @user.valid? # force checking of errors even if function failed
      render :action => :new
  end

  def destroy
    # Only allow an organisation manager to proceed    
    # TODO: catch this better
    unless (@current_user.user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end
    
    # Destroy the function and go back to the list of functions for this organisation
    # TODO: deal with if it doesn't delete properly
    Function.find(params[:id]).destroy
    redirect_to :action => :list
  end

  # Show a printer friendly summary page
  def print
    @function = Function.find(@current_user.function.id)
    
    # Set print_only true and render the normal show action, which will check this variable and include
    # the appropriate CSS as necessary.
    @print_only = true
    render :action => 'show'
  end

  # Opening page where they must choose between Function/Policy and Existing/Proposed
  def status
    @function = Function.find(@current_user.function.id)
    
    # Set hide_menu to true which the application layout will check and hide the menu accordingly
    @hide_menu = true
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
    #["list", "add", "show"].include?(action_name)
  end
end