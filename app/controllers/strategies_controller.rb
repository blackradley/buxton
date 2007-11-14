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
          :xhr => true,
          :only => [ :update_strategy_order ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }
  verify  :method => :post,
          :only => [ :create, :update, :destroy ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # Available to: Administrator
  def index
    list
  end

  # Get the organisation you are considering and a list of it's strategies.
  # Available to: Administrator  
  def list
    @organisation = Organisation.find(params[:id])
    @strategies = @organisation.strategies.find(:all, :order => :position)
  end

  # Drag-and-drop view to re-order the list of strategies for an organisation.
  # Available to: Administrator  
  def reorder
    @organisation = Organisation.find(params[:id])
    @strategies = @organisation.strategies.find(:all, :order => :position)
  end

  # Re-order the strategies for an organisation.
  # Available to: Administrator  
  def update_strategy_order
    params[:sortable_strategies].each_with_index do |id, position|
      # Updates the strategy order - note each_with_index starts at 0 where as
      # acts_as_list expects position 1 to be first. Thus the +1 here to keep it all happy.
      Strategy.update(id, :position => position+1)
    end
  end  

  # Show a strategy's details.
  # Available to: Administrator
  def show
    @strategy = Strategy.find(params[:id])
  end

  # New screen for a strategy.
  # Available to: Administrator
  def new
    @organisation = Organisation.find(params[:id])
    @strategy = @organisation.strategies.build
  end

  # Create a new strategy, the organisation id is derived from.
  # Available to: Administrator  
  def create
    @strategy = Strategy.new(params[:strategy])
    if @strategy.save
      flash[:notice] = 'Strategy was successfully created.'
      redirect_to :action => 'list', :id => @strategy.organisation_id
    else
      render :action => 'new'
    end
  end

  # Edit screen for a strategy.
  # Available to: Administrator
  def edit
    @strategy = Strategy.find(params[:id])
  end

  # Update the strategy attributes.
  # Available to: Administrator  
  def update
    @strategy = Strategy.find(params[:id])
    @strategy.update_attributes!(params[:strategy])

    flash[:notice] = 'Strategy was successfully updated.'
    redirect_to :action => 'show', :id => @strategy
  end

  # Destroy this strategy.
  # Available to: Administrator  
  def destroy
    @strategy = Strategy.find(params[:id])
    @strategy.destroy
    
    flash[:notice] = 'Strategy successfully deleted.'
    redirect_to :action => 'list'
  end
  
protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
end