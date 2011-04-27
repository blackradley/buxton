#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class StrategiesController < ApplicationController

  # verify  :method => :post,
  #         :only => [ :destroy, :create, :update, :update_activity_type, :update_contact, :update_ces ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string
  before_filter :authenticate_user!
  before_filter :ensure_creator
  
  def index
    @breadcrumb = [["Strategic Outcomes"]]
    @strategies = Strategy.all
    @selected = "strategies"
  end
  
  def new
    @breadcrumb = [["Strategic Outcomes", strategies_path], ["Add Strategic Outcome"]]
    @strategy = Strategy.new
    @selected = "strategies"
  end

  def create
    @breadcrumb = [["Strategic Outcomes", strategies_path], ["Add New Strategic Outcome"]]
    @strategy = Strategy.new(params[:strategy])    
    @selected = "strategies"
    if @strategy.save
      flash[:notice] = "#{@strategy.name} was created."
      redirect_to :controller => 'strategies', :action => 'index'
    else
      render 'new'
    end
  end
  
  
  def edit
    @breadcrumb = [["Strategic Outcomes", strategies_path], ["Edit Strategic Outcome"]]
    @strategy = Strategy.find(params[:id])
    @selected = "strategies"
  end

  def update
    @breadcrumb = [["Strategic Outcomes", strategies_path], ["Edit Strategic Outcome"]]
    @strategy = Strategy.find(params[:id])
    @selected = "strategies"
    if @strategy.update_attributes!(params[:strategy])
      flash[:notice] = "#{@strategy.name} was updated."
      redirect_to strategies_path
    else
      render "edit"
    end
  end
  

protected

end
