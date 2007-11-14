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
  verify  :method => :post,
          :only => [ :destroy, :create, :update, :update_status, :update_contact ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # By default, show the summary page. Not presently referenced anywhere.
  # Available to: Organisation Manager
  def index
    summary
  end

  # These are summary statistics for all the functions within this organisation.
  # Available to: Organisation Manager
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

  # Show the summary information for a specific function.
  # Available to: Function Manager
  def show
    @function = Function.find(@current_user.function.id)
  end

  # Shows the section matrix state for a specific function.
  # Available to: Function Manager
  def overview
    @function = Function.find(@current_user.function.id)
  end
  
  # List and provide a summary of the state of all the functions in this organisation.
  # Available to: Organisation Manager
  def list
    @organisation = Organisation.find(@current_user.organisation.id)
  end
  
  # Create a new Function and a new associated user, all functions must have single a valid User.
  # Available to: Organisation Manager
  def new
    @function = Function.new
    @user = User.new
  end

  # Create a new function and a new user based on the parameters in the form data.
  # Available to: Organisation Manager  
  def create
    @function = @current_user.organisation.functions.build(params[:function])
    @user = @function.build_user(params[:user])
    @user.user_type = User::TYPE[:functional]
    @user.passkey = User.generate_passkey(@user)

    begin
      Function.transaction do
        @function.save!
        flash[:notice] = "#{@function.name} was created."
        redirect_to :action => :list
      end
    rescue ActiveRecord::RecordNotSaved
        flash[:notice] = "Function creation failed. Please try again, and if it continues to fail, contact an administrator."
        render :action => :new    
    end
  end

  # Update the function details accordingly.
  # Available to: Function Manager  
  def update
    @function = Function.find(@current_user.function.id)
    @function.update_attributes(params[:function])

    flash[:notice] =  "#{@function.name} was successfully updated."
    redirect_to :back
  end

  # Opening page where they must choose between Function/Policy and Existing/Proposed
  # Available to: Function Manager
  def status
    @function = Function.find(@current_user.function.id)
    
    # Set hide_menu to true which the application layout will check and hide the menu accordingly
    @hide_menu = true
  end

  # Update the function status and proceed, or not, accordingly
  # Available to: Function Manager  
  def update_status
    @function = Function.find(@current_user.function.id)
    @function.update_attributes(params[:function])
    
    # Check both the Function/Policy and Existing/Proposed questions have been answered
    if @function.started then
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
  # Available to: Organisation Manager  
  def edit_contact
    # Only allow an organisation manager to proceed
    # TODO: catch this better
    unless (@current_user.user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end

    # Get the Function and User details ready for the view
    @function = Function.find(params[:id])
    @user = @function.user    
  end

  # Update the contact email and function name
  # Available to: Organisation Manager  
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
    rescue ActiveRecord::RecordInvalid
      @user.valid? # force checking of errors even if function failed
      render :action => :new
  end

  # Delete the function (and any associated records as stated in the Function model)
  # Available to: Organisation Manager
  def destroy
    # Only allow an organisation manager to proceed    
    # TODO: catch this better
    unless (@current_user.user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end
    
    # Destroy the function and go back to the list of functions for this organisation
    @function = Function.find(params[:id])
    @function.destroy

    flash[:notice] = 'Function successfully deleted.'
    redirect_to :action => 'list'
  rescue ActiveRecord::RecordNotFound  
    render :inline => 'Invalid ID.'    
  end

  # Show a printer friendly summary page
  # Available to: Function Manager
  def print
    @function = Function.find(@current_user.function.id)
    
    # Set print_only true and render the normal show action, which will check this variable and include
    # the appropriate CSS as necessary.
    @print_only = true
    render :action => 'show'
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
end