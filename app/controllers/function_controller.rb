#  
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
# 
class FunctionController < ApplicationController
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
    @organisation = Organisation.find(params[:id])
    @functions = Function.find_all_by_organisation_id(params[:id])
    render :action => 'summary', :id => params[:id]
  end
#
# Provide a summary of the state of all the functions for all the
# sections of the review.
#
  def list
    @organisation = Organisation.find(params[:id])
    @functions = Function.find_all_by_organisation_id(params[:id])
    render :action => 'list', :id => params[:id]
  end
#
# List the section 1 (the relevance test) for the functions of an Organisation
# but don't paginate, a long list is actually more convenient for the Organisation
# User to scan down.
#
  def list1
    @organisation = Organisation.find(params[:id])
    @functions = Function.find_all_by_organisation_id(params[:id])
    render :action => 'list1', :id => params[:id]
  end
#
# TODO: List for secton 2
#
  def list2
    @organisation = Organisation.find(params[:id])
    @functions = Function.find_all_by_organisation_id(params[:id])
    render :action => 'list2', :id => params[:id]
  end
#
# TODO: List for secton 3
#
  def list3
    @organisation = Organisation.find(params[:id])
    @functions = Function.find_all_by_organisation_id(params[:id])
    render :action => 'list3', :id => params[:id]
  end
#
# Get the function to show it's summary information
#
  def show
    @function = Function.find(params[:id])
  end
#
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
# Get both the function and user information ready for editing, since they
# are both edited at the same time.  The organisational manager edits these
# not the functional manager.
#
  def edit_contact
    @function = Function.find(params[:id])
    @user = @function.user
  end
#
# Update the contact email and function name
#
  def update_contact
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
# Get the function information ready for editing using the section1 form.  
# These are edited by the functional manager.
#
  def edit_section1
    @function = Function.find(params[:id])
    @strategies = @function.organisation.strategies
    @function_responses = @function.function_strategies # could be empty
    @user = @function.user
  end
#
# Update the function and all of its attributes, then redirect based on the
# type of user.
# 
# TODO: if the user "email" of the user has changed then the "reminded_on"
# date should be set to null.  Because the reminder is when the user was
# reminded so is no longer valid if it is a new user.
# 
  def update_section1
    @function = Function.find(params[:id])
    @function.update_attributes(params[:function])
    params[:function_strategies].each do |function_strategy|
      function_response = @function.function_strategies.find_or_create_by_strategy_id(function_strategy[0])
      function_response.strategy_response = function_strategy[1]
      function_response.save
    end
    flash[:notice] =  @function.name + ' was successfully changed.'
    redirect_to :action => :show, :id => @function
  end
#
# Send a reminder to the email associated with that function.  Only one
# email should be sent for that function, so if the email is used a number
# of times in the functions/users then the other functions are ignored 
# until a reminder is sent for that specific function.
#
  def remind
    @user = User.find(params[:id])
    @user.reminded_on = Time.now
    @user.save
    email = Notifier.create_function_key(@user, request)
    Notifier.deliver(email)
    flash[:notice] = 'Reminder for ' + @user.function.name + ' sent to ' + @user.email
    redirect_to :action => :list1, :id =>  @session['logged_in_user'].organisation.id
  end
#
# TODO: Mark the function record with a deleted date do not destroy
#
  def destroy
    Function.find(params[:id]).destroy
    redirect_to :action => :list, :id =>  @session['logged_in_user'].organisation.id
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
