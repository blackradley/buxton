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
class StrategiesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
#
# Get the organisation you are considering and a list of it's strategies
#
  def list
    @organisation = Organisation.find(params[:id])
    @strategies = Strategy.find_all_by_organisation_id(params[:id])
  end

  def show
    @strategy = Strategy.find(params[:id])
  end

  def new
    @strategy = Strategy.new
    @strategy.organisation_id = params[:id]
  end
#
# Create a new strategy, the organisation id is derived from
#
  def create
    @strategy = Strategy.new(params[:strategy])
    if @strategy.save
      flash[:notice] = 'Strategy was successfully created.'
      redirect_to :action => 'list', :id => @strategy.organisation_id
    else
      render :action => 'new'
    end
  end

  def edit
    @strategy = Strategy.find(params[:id])
  end
#
# Update the strategy attributes
#
  def update
    @strategy = Strategy.find(params[:id])
    if @strategy.update_attributes(params[:strategy])
      flash[:notice] = 'Strategy was successfully updated.'
      redirect_to :action => 'show', :id => @strategy
    else
      render :action => 'edit'
    end
  end
#
# TODO: Mark the strategy record with a deleted date do not destroy
#
  def destroy
    Strategy.find(params[:id]).destroy
    redirect_to :action => 'list'
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
