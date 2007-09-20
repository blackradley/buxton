#
# $URL$
#
# $Rev$
#
# $Author$
#
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class FunctionsController < ApplicationController
#
# By default list the functions.
#
  def index
    render :action => 'summary'
  end
#
# GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
#
# Summary statistics for the functions
#
  def summary
    @organisation = Organisation.find(session['logged_in_user'].organisation.id)
    @functions = @organisation.functions

    @results_table = { 1 => { :high => 0, :medium => 0, :low => 0 },
                      2 => { :high => 0, :medium => 0, :low => 0 }, 
                      3 => { :high => 0, :medium => 0, :low => 0 }, 
                      4 => { :high => 0, :medium => 0, :low => 0 }, 
                      5 => { :high => 0, :medium => 0, :low => 0 } }

    for function in @functions
      if function.completed then
        stats = function.statistics
        @results_table[stats.fun_priority_ranking][stats.fun_impact] += 1
      end
    end
    render :action => 'summary', :id => params[:id]
  end
#
# Show the summary information for a specific function.
# Available to the Function manager.
#
  def show
    @function = Function.find(session['logged_in_user'].function.id)
  end  
#
# Provide a summary of the state of all the functions for all the
# sections of the review.
#
  def list
    @organisation = Organisation.find(session['logged_in_user'].organisation.id)
    render :action => 'list', :id => params[:id]
  end
# Create a new Function and a new associated user, all functions must
# have single a valid User.
#
  def new
    @function = Function.new
    @user = User.new
  end
#
# Create a new function and a new user based on the parameters on the form.
#
  def create
    FunctionStrategy.transaction do
      Function.transaction do
        User.transaction do
          @user = User.new(params[:user])
          @user.user_type = User::TYPE[:organisational]
          @user.save!
          @function = Function.new(params[:function])
          @function.organisation_id = @session['logged_in_user'].organisation.id
          @function.user = @user
          @function.save!
          flash[:notice] = @function.name + ' was created.'
          redirect_to :action => :list, :id =>  @session['logged_in_user'].organisation.id
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new
  end
# 
# Update the function details accordingly. Currently only referenced by the Approval section in Function#show
# 
  def update
    @function = Function.find(session['logged_in_user'].function.id)
    @function.update_attributes(params[:function])

    flash[:notice] =  "#{@function.name} was successfully updated."
    redirect_to :back
  end
#
# Get both the function and user information ready for editing, since they
# are both edited at the same time.  The organisational manager edits these
# not the functional manager.
#
  def edit_contact
    # K: TODO: catch this better
    unless (session['logged_in_user'].user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end

    @function = Function.find(params[:id])
    @user = @function.user    
  end
#
# Update the contact email and function name
#
  def update_contact
    # K: TODO: catch this better
    unless (session['logged_in_user'].user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end

    @function = Function.find(params[:id])
    @function.update_attributes(params[:function])
    Function.transaction do
      @user = @function.user
      @user.update_attributes(params[:user])
      flash[:notice] =  @function.name + ' was successfully changed.'
      redirect_to :action => 'list', :id => @function.organisation
    end
  rescue ActiveRecord::RecordInvalid => e
    @user.valid? # force checking of errors even if function failed
    render :action => :new
  end
#
# TODO: Mark the function record with a deleted date do not destroy
#
  def destroy
    # K: TODO: catch this better
    unless (session['logged_in_user'].user_type == User::TYPE[:organisational]) then render :inline => 'Invalid.' end
    
    Function.find(params[:id]).destroy
    redirect_to :action => :list, :id =>  @session['logged_in_user'].organisation.id
  end

# 
# Show a printer friendly summary page
# 
  def print
    @function = Function.find(@session['logged_in_user'].function.id)
    @print_only = true
    render :action => 'show'
  end

protected
#
# Secure the relevant methods in the controller.
#
  def secure?
    true
    #["list", "add", "show"].include?(action_name)
  end
end
