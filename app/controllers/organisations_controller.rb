#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/controllers/organisations_controller.rb $
# $Rev: 678 $
# $Author: 27stars-karl $
# $Date: 2007-12-17 09:20:53 +0000 (Mon, 17 Dec 2007) $
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class OrganisationsController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  render_options = { :status => 405 }
  verify :method => :post, :only => [ :create ], :render => render_options
  verify :method => :put, :only => [ :update ], :render => render_options
  verify :method => :delete, :only => [ :destroy ], :render => render_options

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # List the organisation for the administrative User. Paginate with 10 organisations listed per page.
  # Available to: Administrator
  def index
    @organisations = Organisation.paginate(:page => params[:page], :per_page => 10)
  end

  # Show a view of an individual Organisation
  # Available to: Administrator
  def show
    @organisation = Organisation.find(params[:id])
    @directorates = @organisation.directorates
    @organisation_managers = @organisation.organisation_managers
  end

  # Create a new Organisation and a new associated User
  # Available to: Administrator
  def new
    @organisation = Organisation.new    
    @organisation_terminologies = Terminology.find(:all).map do |term|
      @organisation.organisation_terminologies.build(:value => term.term, :terminology_id => term.id)
    end
  end

  # Create a new organisation and a new user based on the parameters on the form.
  # Available to: Administrator
  def create
    ot_attributes = params['organisation']['organisation_terminology_attributes']
    params['organisation'].delete('organisation_terminology_attributes')
    @organisation = Organisation.new(params[:organisation])
    Organisation.transaction do
      org_terms = @organisation.organisation_terminologies
      ot_attributes.each do |ot|
        org_terms.build(:value => ot['value'], :terminology_id => ot['terminology_id']).save
      end
      @organisation.save!
      flash[:notice] = "#{@organisation.name} was created."
      redirect_to organisations_url
    end
  end

  # Get both the organisation and it's user since the user can also be edited
  # by the administrator.
  # Available to: Administrator
  def edit
    @organisation = Organisation.find(params[:id])
    @organisation_managers = @organisation.organisation_managers
    @organisation_terminologies = Terminology.find(:all).map do |term|
      if term = @organisation.organisation_terminologies.find_by_terminology_id(term.id) then
        term  
      else
        @organisation.organisation_terminologies.build(:value => term.term, :terminology_id => term.id)
      end
    end
  end

  # Update the organisation and all of its attributes
  # Available to: Administrator
  def update
    @organisation = Organisation.find(params[:id])
    @organisation_managers = @organisation.organisation_managers
    org_terms = @organisation.organisation_terminologies
    Organisation.transaction do
      params['organisation']['organisation_terminology_attributes'].each do |ot|
        if org_term = org_terms.find_by_terminology_id(ot['terminology_id']) then
          org_term.update_attributes!(:value => ot['value']) unless ot['value'] == org_term.value
        else
          org_terms.build(:value => ot['value'], :terminology_id => ot['terminology_id']).save
        end
      end
      params['organisation'].delete('organisation_terminology_attributes')
      @organisation.update_attributes!(params[:organisation])
      flash[:notice] = "#{@organisation.name} was successfully changed."
      redirect_to organisations_url
    end
  end

  # Destroy the organisation
  # Available to: Administrator
  def destroy
    @organisation = Organisation.find(params[:id])
    @organisation.destroy

    flash[:notice] = 'Organisation successfully deleted.'
    redirect_to organisations_url
  end

  def view_pdf
    @belonging = case @current_user.class.name
      when 'OrganisationManager'
        @current_user.organisation
      when 'DirectorateManager'
        @current_user.directorate
      when 'ProjectManager'
        @current_user.project
    end
    log_event('PDF', %Q[The #{@current_user.level} manager PDF for <strong>#{@belonging.name}</strong> was viewed.])
    send_data OrganisationPDFGenerator.new(@belonging).pdf.render, :disposition => 'inline',
      :filename => "#{@belonging.name}.pdf",
      :type => "application/pdf"
  end

protected
  # Secure the relevant methods in the controller.
  def secure?
    true
  end

  def show_errors(exception)
    flash[:notice] = 'Organisation could not be updated.'
    render :action => (exception.record.new_record? ? :new : :edit)
  end
end
