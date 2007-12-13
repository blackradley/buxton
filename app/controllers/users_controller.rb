#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class UsersController < ApplicationController
  filter_parameter_logging :passkey

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify  :method => :post,
          :only => [ :create, :update, :destroy, :new_link, :remind ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  rescue_from ActiveRecord::RecordNotSaved, :with => :show_errors
  rescue_from ActiveRecord::RecordInvalid, :with => :show_errors

  # Present a form to request a lost passkey by entering your e-mail address.
  # Available to: anybody
  def index
    # Log out the user if they are logged in
    logout()
  end

  # List all admins.
  # Available to: Administrator
  def list
    @admins = Administrator.find(:all)
  end

  # New screen for a user.
  # Available to: Administrator
  def new
    @admin = Administrator.new
  end

  # You can only create an administrative user, the other users have
  # to be created in conjunction with the organisation or activity
  # that they will be responsible for.
  # Available to: Administrator  
  def create
    @admin = Administrator.new(params[:admin])
    @admin.passkey = Administrator.generate_passkey(@admin)
    @admin.save!
    flash[:notice] = 'Admin was successfully created.'
    redirect_to :action => 'list'
  end

  # Edit screen for a user.
  # Available to: Administrator  
  def edit
    @admin = Administrator.find(params[:id])
  end

  # Update a user's details.
  # [Disabled] Give the user a new key every time it is updated
  # TODO: check whether this should be enabled
  # Available to: Administrator
  def update
    @admin = Administrator.find(params[:id])
    # @user.passkey = User.new_passkey # TODO: check whether this should be enabled
    @admin.update_attributes!(params[:admin])

    flash[:notice] = "#{@admin.email} was successfully updated."
    redirect_to :action => 'list'
  end

  # Find the user and then send them a new key
  #
  # Unlike controllers from Action Pack, the mailer instance doesn't
  # have any context about the incoming request. So the request is
  # passed in explicitly.
  #
  # TODO: I am not sure that this actually works, check that if you have
  # a user that is operational user and a number of activityal users, do
  # the links actually match up with the activities.
  # 
  # Available to: anybody
  def new_link
    @users = User.find_all_by_email(params[:email])
    if @users.empty?
      flash[:notice] = 'Unknown Email'
    else
      for @user in @users
        # new_passkey(@user)
        case @user.class.name
          when 'ActivityManager'
            email = Notifier.create_activity_key(@user, request)
            Notifier.deliver(email)
            @user.reminded_on = Time.now.gmtime
            @user.save
           when 'OrganisationManager'
            email = Notifier.create_organisation_key(@user, request)
            Notifier.deliver(email)
            @user.reminded_on = Time.now.gmtime
            @user.save
          when 'Administrator'
            email = Notifier.create_administration_key(@user, request)
            Notifier.deliver(email)
            @user.reminded_on = Time.now.gmtime
            @user.save
        end
      end
      flash[:notice] = "New link#{@users.length >= 2 ? 's' : ''} sent to #{@user.email}"
    end
    redirect_to :action => 'index'
  end

  # Destroy the user
  # Available to: Administrator
  def destroy
    @admin = Administrator.find(params[:id])
    @admin.destroy
    
    flash[:notice] = 'User successfully deleted.'
    redirect_to :action => 'list'
  rescue ActiveRecord::RecordNotFound  
    render :inline => 'Invalid ID.'    
  end
  
  # Send a passkey reminder to the email associated with this user. Only one e-mail will be sent and
  # it will use the Organisation Manager or Activity Manager template accordingly.
  # The system currently does not allow for a user to be both types of manager. If it did, this would not work.
  # TODO: check the logic associated with this, see also: User#new_link
  # Available to: Administrator
  #               Organisation Manager
  def remind
    @user = User.find(params[:id])
    
    # Are they a activity manager?
    case @user.class.name
    when 'ActivityManager'
      email = Notifier.create_activity_key(@user, request)
      flash[:notice] = 'Reminder for ' + @user.activity.name + ' sent to ' + @user.email
    # Nope, are they an organisation manager?
    when 'OrganisationManager'
      email = Notifier.create_organisation_key(@user, request)
      flash[:notice] = "Reminder for #{@user.organisation.name} sent to #{@user.email}"
    # Nope. Well do nothing then.
    else
      # Shouldn't get here - but let them know what happened anyway
      # TODO: throw exception in dev mode?
      flash[:notice] = 'No reminder e-mail sent. This user does not manage anything.'
      redirect_to :back
    end
    
    # Send the reminder e-mail
    Notifier.deliver(email)
    # Update the time we reminded them
    @user.reminded_on = Time.now.gmtime
    @user.save
    
    redirect_to :back
  rescue ActiveRecord::RecordNotFound
    render :inline => 'Invalid ID.'    
  end

  # Log the user in and then direct them to the right place based on the user type
  # Available to: anybody
  def login
    user = User.find_by_passkey(params[:passkey])
    if user.nil? # the key is not in the user table
      flash[:notice] = 'Out of date link, enter your email to receive a new one'
      redirect_to :action => 'index'
    else # the key is in the table so stash the user
      session[:user_id] = user.id
      case user.class.name
        when 'ActivityManager'
          redirect_to :controller => 'activities', :action => 'index'
        when 'OrganisationManager'
          redirect_to :controller => 'activities', :action => 'summary'
        when 'Administrator'
          redirect_to :controller => 'organisations', :action => 'list'
      end
    end
  end
  
protected
  # No methods are secure
  def secure?
    false
  end

  def show_errors(exception)
    flash[:notice] = 'User could not be updated.'
    render :action => (exception.record.new_record? ? :new : :edit) 
  end
end