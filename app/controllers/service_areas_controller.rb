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

  # rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  # rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string
  before_filter :authenticate_user!
  before_filter :ensure_access
  before_filter :set_service_area, :only => [:edit, :update, :toggle_retired_status]
  autocomplete :user, :email, :scope => :live

  def index
    @breadcrumb = [["Service Areas"]]
    # @service_areas = ServiceArea.where(:directorate_id => Directorate.where(:creator_id=>current_user.id).map(&:id))
    @service_areas = current_user.cop_service_areas
    # @service_areas = @service_areas.uniq
    @selected = "service_areas"
  end

  def new
    @breadcrumb = [["Service Areas", service_areas_path], ["Add New Service Area"]]
    @service_area = ServiceArea.new
    @directorates = Directorate.where(:retired => false)
    @selected = "service_areas"
  end

  def create
    @breadcrumb = [["Service Areas", service_areas_path], ["Add New Service Area"]]
    @service_area = ServiceArea.new(params[:service_area])
    @directorate = current_user.all_directorates.first
    @service_area.directorate = @directorate unless @service_area.directorate
    @selected = "service_areas"
    if @service_area.save
      flash[:notice] = "#{@service_area.name} was created."
      redirect_to :controller => 'service_areas', :action => 'index'
    else
      @directorates = Directorate.where(:retired => false)
      render 'new'
    end
  end

  def toggle_retired_status
    @service_area.toggle(params[:checkbox])
    @service_area.save
    render :nothing => true
  end


  def edit
    @breadcrumb = [["Service Areas", service_areas_path], ["Edit Service Area"]]
    @directorates = Directorate.where(:retired => false)
    @selected = "service_areas"
  end

  def update
    @breadcrumb = [["Service Areas", service_areas_path], ["Edit Service Area"]]
    @directorate = current_user.all_directorates.first
    @service_area.directorate = @directorate unless @service_area.directorate
    @selected = "service_areas"
    if @service_area.update_attributes(params[:service_area])
      flash[:notice] = "#{@service_area.name} was updated."
      redirect_to service_areas_path
    else
      @directorates = Directorate.where(:retired => false)
      render "edit"
    end
  end


protected

  def ensure_access
    redirect_to access_denied_path if !current_user.directorate_cop?
  end

  def set_service_area
    @service_area = ServiceArea.find_by(id: params[:id])
    unless (current_user.directorate && current_user.directorate.service_areas.include?( @service_area )) || current_user.cop_service_areas.include?( @service_area )
      redirect_to access_denied_path
      return false
    end
  end

end
