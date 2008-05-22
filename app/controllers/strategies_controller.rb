#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class StrategiesController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :xhr => true,
          :only => [ :update_strategy_order ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }
  # verify  :method => :post,
  #          :only => [ :create, :update, :destroy ],
  #          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }
 
  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors
  
  # Strategies are nested resources underneath Organisations,
  # so we'll always have an Organisation to load first.
  before_filter :load_organisation
  
  # Get the organisation you are considering and a list of it's strategies.
  # Available to: Administrator  
  def index
    @strategies = @organisation.strategies.find(:all, :order => :position)
  end

  # Show a strategy's details.
  # Available to: Administrator
  def show
    @strategy = @organisation.strategies.find(params[:id])
  end

  # New screen for a strategy.
  # Available to: Administrator
  def new
    @strategy = @organisation.strategies.build
  end

  # Create a new strategy, the organisation id is derived from.
  # Available to: Administrator  
  def create
    @strategy = @organisation.strategies.build(params[:strategy])
    @strategy.save!
    flash[:notice] = 'Strategy was successfully created.'
    redirect_to organisation_strategies_url(@organisation)
  end

  # Edit screen for a strategy.
  # Available to: Administrator
  def edit
    @strategy = @organisation.strategies.find(params[:id])
  end

  # Update the strategy attributes.
  # Available to: Administrator  
  def update
    @strategy = @organisation.strategies.find(params[:id])
    @strategy.update_attributes!(params[:strategy])

    flash[:notice] = 'Strategy was successfully updated.'
    redirect_to organisation_strategy_url(@organisation, @strategy)
  end

  # Destroy this strategy.
  # Available to: Administrator  
  def destroy
    @strategy = @organisation.strategies.find(params[:id])
    @strategy.destroy
    
    flash[:notice] = 'Strategy successfully deleted.'
    redirect_to organisation_strategies_url(@organisation)
  end

  # Drag-and-drop view to re-order the list of strategies for an organisation.
  # Available to: Administrator  
  def reorder
    @strategies = @organisation.strategies.find(:all, :order => :position)
  end

  # Re-order the strategies for an organisation.
  # Available to: Administrator  
  def update_strategy_order
    params[:sortable_strategies].each_with_index do |id, position|
      # Updates the strategy order - note each_with_index starts at 0 where as
      # acts_as_list expects position 1 to be first. Thus the +1 here to keep it all happy.
      @organisation.strategies.update(id, :position => position+1)
    end
    render :nothing => true
  end  
  
protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
  
  # rescue_from
  def show_errors(exception)
    flash[:notice] = 'Strategy could not be updated.'
    render :action => (exception.record.new_record? ? :new : :edit) 
  end
  
private

  # before_filter
  def load_organisation
    @organisation = Organisation.find(params[:organisation_id])
  end
  
end