#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
class StrategiesController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :destroy, :create, :update ],
          :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  # Get the organisation you are considering and a list of it's strategies
  def list
    @organisation = Organisation.find(params[:id])
    @strategies = @organisation.strategies.find(:all, :order => :position)
  end
  
  def reorder
    @organisation = Organisation.find(params[:id])
    @strategies = @organisation.strategies.find(:all, :order => :position)
  end
  
  def update_strategy_order
    params[:sortable_strategies].each_with_index do |id, position|
      # Updates the strategy order - note each_with_index starts at 0 where as
      # acts_as_list expects position 1 to be first. Thus the +1 here to keep it all happy.
      Strategy.update(id, :position => position+1)
    end
  end  

  def show
    @strategy = Strategy.find(params[:id])
  end

  def new
    @strategy = Strategy.new
    @strategy.organisation_id = params[:id]
  end

  # Create a new strategy, the organisation id is derived from
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

  # Update the strategy attributes
  def update
    @strategy = Strategy.find(params[:id])
    if @strategy.update_attributes(params[:strategy])
      flash[:notice] = 'Strategy was successfully updated.'
      redirect_to :action => 'show', :id => @strategy
    else
      render :action => 'edit'
    end
  end

  # Destroy this strategy
  def destroy
    @strategy = Strategy.find(params[:id])
    @strategy.destroy
    
    flash[:notice] = 'Strategy successfully deleted.'
    redirect_to :action => 'list'
  rescue ActiveRecord::RecordNotFound => e  
    render :inline => 'Invalid ID.'
  end
  
protected
  # Secure the relevant methods in the controller.
  def secure?
    true
    #["list", "add", "show"].include?(action_name)
  end
end