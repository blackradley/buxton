#
# $URL$
# $Author$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class OrganisationsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :destroy, :create, :update ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # Available to: Administrator
  def index
    list
  end

  # List the organisation for the administrative User. Paginate with 10 organisations listed per page.
  # Available to: Administrator  
  def list
    @organisations = Organisation.paginate(:page => params[:page], :per_page => 10)
  end

  # Show a view of an individual Organisation
  # Available to: Administrator  
  def show
    @organisation = Organisation.find(params[:id])
    @directorates = @organisation.directorates
    @organisation_manager = @organisation.organisation_manager
  end

  # Create a new Organisation and a new associated User
  # Available to: Administrator  
  def new
    @organisation = Organisation.new
    @organisation_manager = @organisation.build_organisation_manager
  end

  # Create a new organisation and a new user based on the parameters on the form.
  # Available to: Administrator  
  def create
    @organisation = Organisation.new(params[:organisation])
    params[:directorates].each{ |name| @organisation.directorates.build(:name => name) }
    @organisation_manager = @organisation.build_organisation_manager(params[:organisation_manager])
    @organisation_manager.passkey = OrganisationManager.generate_passkey(@organisation_manager)

    Organisation.transaction do
      @organisation.save!
      flash[:notice] = "#{@organisation.name} was created."
      redirect_to :action => :list
    end
  end

  # Get both the organisation and it's user since the user can also be edited
  # by the administrator.
  # Available to: Administrator  
  def edit
    @organisation = Organisation.find(params[:id])
    @organisation_manager = @organisation.organisation_manager
  end

  # Update the organisation and all of its attributes
  # Available to: Administrator  
  def update
    @organisation = Organisation.find(params[:id])
    Organisation.transaction do
      @organisation.update_attributes!(params[:organisation])
      @organisation_manager = @organisation.organisation_manager
      @organisation_manager.update_attributes!(params[:organisation_manager])
      flash[:notice] =  "#{@organisation.name} was successfully changed."
      redirect_to :action => 'show', :id => @organisation
    end
  end
  
  # Destroy the organisation
  # Available to: Administrator  
  def destroy
    @organisation = Organisation.find(params[:id])
    @organisation.destroy

    flash[:notice] = 'Organisation successfully deleted.'
    redirect_to :action => 'list'
  end

  def view_pdf
    @organisation = Organisation.find(@current_user.organisation.id)
    send_data  OrganisationPDFRenderer.render_pdf(:data => @organisation.generate_pdf_data),
      :type         => "application/pdf",
      :disposition  => "inline",
      :filename     => "report.pdf" 
  end
protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end
end
