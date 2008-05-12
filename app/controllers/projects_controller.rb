class ProjectsController < ApplicationController
  def new
    @project = Project.new(:organisation_id => params[:organisation_id])
    @project_manager = @project.build_project_manager
  end

  def create
    @project = Project.new(params[:project])
    Project.transaction do
      @project.build_project_manager(params[:project_manager])
      @project.save!
      flash[:notice] = "#{@project.name} was created."
      redirect_to organisation_projects_url
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def show
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    Project.transaction do
      @project.update_attributes!(params[:project])
      @project.project_manager.update_attributes(params[:project_manager])
      flash[:notice] = "#{@project.name} was successfully changed."
      redirect_to organisation_projects_url
    end
  end

  def index
    @organisation = Organisation.find(params[:organisation_id])
    @projects = @organisation.projects
  end

  def destroy
    @project = Project.find(params[:id])
    org = @project.organisation
    @project.destroy
    redirect_to organisation_projects_url
  end
end
