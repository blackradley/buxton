#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class DirectoratesController < ApplicationController

  # verify  :method => :post,
  #         :only => [ :destroy, :create, :update, :update_activity_type, :update_contact, :update_ces ],
  #         :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Make render_to_string available to the #show action
  helper_method :render_to_string
  before_filter :authenticate_user!
  before_filter :ensure_creator
  # autocomplete :user, :email, :scope => :live
  autocomplete :user, :email, :scope => :creator
  
  def index
    @breadcrumb = [["Directorates"]]
    @directorates = Directorate.all
    @selected = "directorates"
  end
  
  def new
    @breadcrumb = [["Directorates", directorates_path], ["Add New Directorate"]]
    @directorate = Directorate.new
    @selected = "directorates"
  end

  def create
    @breadcrumb = [["Directorates", directorates_path], ["Add New Directorate"]]
    @directorate = Directorate.new(params[:directorate])
    @selected = "directorates"
    if @directorate.save
      flash[:notice] = "#{@directorate.name} was created."
      redirect_to :controller => 'directorates', :action => 'index'
    else
      render 'new'
    end
  end
  
  
  def edit
    @breadcrumb = [["Directorates", directorates_path], ["Edit Directorate"]]
    @directorate = Directorate.find(params[:id])
    @selected = "directorates"
  end

  def update
    @breadcrumb = [["Directorates", directorates_path], ["Edit Directorate"]]
    @directorate = Directorate.find(params[:id])
    @selected = "directorates"
    if @directorate.update_attributes!(params[:directorate])
      flash[:notice] = "#{@directorate.name} was updated."
      redirect_to directorates_path
    else
      render "edit"
    end
  end
  

protected

end
