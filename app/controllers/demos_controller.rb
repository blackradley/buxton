# 
# $URL$ 
# $Author$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.  
# 
class DemosController < ApplicationController

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :create ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Available to: anybody
  def new
  end

  # Create a new user and organisation, then log the user in.  Obviously this
  # bypasses the minimal security, but it is just a demo.  If the user is already
  # an organisational user the they go straight to the login.  So we don't get
  # multiple demo organisations for the same user.
  #
  # If an admin user requests a demo then one is created for them since the
  # admin users are not sought in the first find.
  # 
  # Available to: anybody
  def create
    @organisation_manager = OrganisationManager.find(:first, :conditions => { :email => params[:organisation_manager][:email] })

    if @organisation_manager.nil? then
      # Create an organisation
      @organisation = Organisation.new({ :name => 'Demo Council', :style => 'www' })
      
      # Create a new organisation manager with the e-mail address we were given
      @organisation_manager = @organisation.build_organisation_manager(params[:organisation_manager])
      @organisation_manager.passkey = OrganisationManager.generate_passkey(@organisation_manager)

      # Give the organisation some strategies
      strategy_names = ['Manage resources effectively, flexibly and responsively',
        'Investing in our staff to build an organisation that is fit for its purpose',
        'Raising performance in our services for children, young people, families and adult',
        'Raising performance in our housing services',
        'Cleaner, greener and safer environment',
        'Investing in regeneration',
        'Improving our transport and tackling congestion',
        'Providing more effective education and leisure opportunities']
      strategy_names.each { |strategy_name|
        strategy = @organisation.strategies.build
        strategy.name = strategy_name
        strategy.description = strategy_name
      }

      # Give the organisation five directorates
      directorate_names = ["Adult, Community and Housing Services","Childrens Services","Finance, ICT and Procurement","Law and Property","Urban Environment"]
      directorate_names.each { |directorate_name|
        # Create a directorate
        directorate = @organisation.directorates.build(:name => directorate_name)
        # directorate.organisation = @organisation #this should be filled in directly above, don't know why not

        activity_names = ['Activity 1','Activity 2','Activity 3']
        activity_names.each { |activity_name|
          # Create a activity
          activity = directorate.activities.build(:name => activity_name)
          # Create a activity manager
          activity_manager = activity.build_activity_manager(params[:organisation_manager])
          activity_manager.passkey = ActivityManager.generate_passkey(activity_manager)
        }        
      }
      
      Organisation.transaction do
        @organisation.save!
        flash[:notice] = 'Demonstration organisation was created.'
      end
    end

    # If we made it here then all of the above was successful.
    # Log in the organisational manager (be they new or old).
    redirect_to :controller => 'users', :action => :login, :passkey => @organisation_manager.passkey
  end

protected

  def show_errors(exception)
    flash[:notice] = "Unable to create demo. Please check for errors and try again."
    render :action => :new
  end

end