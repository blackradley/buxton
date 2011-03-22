#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ServiceAreasController < ApplicationController

  # verify  :method => :post,
  #         :only => [ :destroy, :create, :update, :update_activity_type, :update_contact, :update_ces ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string
  before_filter :authenticate_user!
  before_filter :ensure_creator
  autocomplete :user, :email, :scope => :live
  
  def index
    @breadcrumb = [["Service Areas"]]
    @service_areas = ServiceArea.all
    @selected = "service_areas"
  end
  
  def new
    @breadcrumb = [["Service Areas", service_areas_path], ["Add New Service Area"]]
    @service_area = ServiceArea.new
    @selected = "service_areas"
  end

  def create
    @breadcrumb = [["Service Areas", service_areas_path], ["Add New Service Area"]]
    @service_area = ServiceArea.new(params[:service_area])
    @selected = "service_areas"
    if @service_area.save
      flash[:notice] = "#{@service_area.name} was created."
      redirect_to :controller => 'service_areas', :action => 'index'
    else
      render 'new'
    end
  end
  
  
  def edit
    @breadcrumb = [["Service Areas", service_areas_path], ["Edit Service Area"]]
    @service_area = ServiceArea.find(params[:id])
    @selected = "service_areas"
  end

  def update
    @breadcrumb = [["Service Areas", service_areas_path], ["Edit Service Area"]]
    @service_area = ServiceArea.find(params[:id])
    @selected = "service_areas"
    if @service_area.update_attributes!(params[:service_area])
      flash[:notice] = "#{@service_area.name} was updated."
      redirect_to service_areas_path
    else
      render "edit"
    end
  end
  

protected

end
