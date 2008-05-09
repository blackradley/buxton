class DirectoratesController < ApplicationController
  def new
    @directorate = Directorate.new(:organisation_id => params[:organisation_id])
    @directorate_manager = @directorate.build_directorate_manager
  end

  def create
    @directorate = Directorate.new(params[:directorate])
    Directorate.transaction do
      @directorate.build_directorate_manager(params[:directorate_manager])
      @directorate.save!
      flash[:notice] = "#{@directorate.name} was created."
      redirect_to organisation_directorates_url
    end
  end

  def edit
    @directorate = Directorate.find(params[:id])
  end

  def show
    @directorate = Directorate.find(params[:id])
  end

  def update
    @directorate = Directorate.find(params[:id])
    Directorate.transaction do
      @directorate.update_attributes!(params[:directorate])
      @directorate.directorate_manager.update_attributes(params[:directorate_manager])
      flash[:notice] = "#{@directorate.name} was successfully changed."
      redirect_to organisation_directorates_url
    end
  end

  def index
    @organisation = Organisation.find(params[:organisation_id])
    @directorates = @organisation.directorates
  end

  def destroy
    @directorate = Directorate.find(params[:id])
    org = @directorate.organisation
    @directorate.destroy
    redirect_to organisation_directorates_url
  end
end