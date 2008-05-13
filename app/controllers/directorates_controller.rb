class DirectoratesController < GroupingsController

  def index
    @directorates = @organisation.directorates
  end

  def show
    @directorate = @organisation.directorates.find(params[:id])
  end

  def new
    @directorate = @organisation.directorates.build
    @directorate_manager = @directorate.build_directorate_manager
  end

  def create
    @directorate = @organisation.directorates.build(params[:directorate])
    Directorate.transaction do
      @directorate.build_directorate_manager(params[:directorate_manager])
      @directorate.save!
      flash[:notice] = "#{@directorate.name} was created."
      redirect_to organisation_directorates_url
    end
  end

  def edit
    @directorate = @organisation.directorates.find(params[:id])
  end

  def update
    @directorate = @organisation.directorates.find(params[:id])
    Directorate.transaction do
      @directorate.update_attributes(params[:directorate])
      @directorate.directorate_manager.update_attributes(params[:directorate_manager])
      flash[:notice] = "#{@directorate.name} was successfully changed."
      redirect_to organisation_directorates_url
    end
  end

  def destroy
    @directorate = @organisation.directorates.find(params[:id])
    @directorate.destroy
    redirect_to organisation_directorates_url
  end
  
end