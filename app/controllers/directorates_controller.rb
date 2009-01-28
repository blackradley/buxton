#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class DirectoratesController < GroupingsController
  
  before_filter :verify_index_access, :only => [:index, :new, :create]
  before_filter :verify_edit_access, :only => [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  def index
    @directorates = @organisation.directorates
  end

  def show
#    @directorate = @organisation.directorates.find(params[:id])
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
#    @directorate = @organisation.directorates.find(params[:id])
    
    # If we already have a directorate manager, use it
    unless @directorate.directorate_manager.nil?
      @directorate_manager = @directorate.directorate_manager
    else
      # If not, create a new one
      # This second step is needed where we have some directorates without directorate managers
      # since the introduction of directorate managers.
      # This can be removed in the future where no installations in this state.
      @directorate_manager = @directorate.build_directorate_manager
    end    
  end

  def update
#    @directorate = @organisation.directorates.find(params[:id])
    Directorate.transaction do
      @directorate.update_attributes(params[:directorate])

      # If we already have a directorate manager, use it
      unless @directorate.directorate_manager.nil?
        @directorate.directorate_manager.update_attributes(params[:directorate_manager])
      else
        # If not, create a new one
        # This second step is needed where we have some directorates without directorate managers
        # since the introduction of directorate managers.
        # This can be removed in the future where no installations in this state.
        directorate_manager = @directorate.build_directorate_manager(:email => params['directorate_manager']['email'].strip)
        directorate_manager.save!
      end
      
      flash[:notice] = "#{@directorate.name} was successfully changed."
      redirect_to organisation_directorates_url
    end
  end

  def destroy
#    @directorate = @organisation.directorates.find(params[:id])
    @directorate.destroy
    redirect_to organisation_directorates_url
  end
  
  def view_pdf
    @directorate = @current_user.directorate
    log_event('PDF', %Q[The directorate manager PDF for <strong>#{@directorate.name}</strong> was viewed.])
    send_data OrganisationPDFGenerator.new(@directorate).pdf.render, :disposition => 'inline',
      :filename => "#{@directorate.name}.pdf",
      :type => "application/pdf"
  end
  
  protected
  
    def get_related_model
      Directorate
    end

    def show_errors(exception)
      flash[:notice] = 'Directorate could not be updated.'
      render :action => (exception.record.new_record? ? :new : :edit)
    end


end
