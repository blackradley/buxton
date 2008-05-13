#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/controllers/organisations_controller.rb $
# $Rev: 678 $
# $Author: 27stars-karl $
# $Date: 2007-12-17 09:20:53 +0000 (Mon, 17 Dec 2007) $
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
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
    @organisation = Organisation.new(params[:organisation])
    Organisation.transaction do
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
      @organisation.organisation_terminologies.build(:value => term.term, :terminology_id => term.id)
    end
  end

  # Update the organisation and all of its attributes
  # Available to: Administrator
  def update
    @organisation = Organisation.find(params[:id])
    @organisation_managers = @organisation.organisation_managers
    @organisation_terminologies = Terminology.find(:all).map do |term|
      @organisation.organisation_terminologies.build(:value => term.term, :terminology_id => term.id)
    end
    Organisation.transaction do
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
    @organisation = @current_user.organisation
    PDFLog.create(:message => %Q[The organisation manager PDF for <strong>#{@organisation.name}</strong> was viewed.])
    send_data OrganisationPDFGenerator.new(@organisation).pdf.render, :disposition => 'inline',
      :filename => "#{@organisation.name}.pdf",
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
