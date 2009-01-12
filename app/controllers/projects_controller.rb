#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ProjectsController < GroupingsController
  
  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  def index
    @projects = @organisation.projects
  end

  def show
    @project = @organisation.projects.find(params[:id])
  end

  def new
    @project = @organisation.projects.build
    @project_manager = @project.build_project_manager
  end

  def create
    @project = @organisation.projects.build(params[:project])
    Project.transaction do
      @project.build_project_manager(params[:project_manager])
      @project.save!
      flash[:notice] = "#{@project.name} was created."
      redirect_to organisation_projects_url
    end
  end

  def edit
    @project = @organisation.projects.find(params[:id])
  end

  def update
    @project = @organisation.projects.find(params[:id])
    Project.transaction do
      @project.update_attributes!(params[:project])
      @project.project_manager.update_attributes(params[:project_manager])
      flash[:notice] = "#{@project.name} was successfully changed."
      redirect_to organisation_projects_url
    end
  end

  def destroy
    @project = @organisation.projects.find(params[:id])
    @project.destroy
    redirect_to organisation_projects_url
  end
  
  protected

    def show_errors(exception)
      flash[:notice] = 'Project could not be updated.'
      render :action => (exception.record.new_record? ? :new : :edit)
    end
end
