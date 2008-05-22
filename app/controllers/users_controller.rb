#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
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
    render :layout => 'productPage'
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
        @login_url = @user.url_for_login(request)
        case @user.class.name
          when 'ActivityManager'
            email = Notifier.create_activity_key(@user, @login_url)
            Notifier.deliver(email)
            @user.reminded_on = Time.now
            @user.save
           when 'OrganisationManager'
            email = Notifier.create_organisation_key(@user, @login_url)
            Notifier.deliver(email)
            @user.reminded_on = Time.now
            @user.save
          when 'Administrator'
            email = Notifier.create_administration_key(@user, @login_url)
            Notifier.deliver(email)
            @user.reminded_on = Time.now
            @user.save
          when 'DirectorateManager'
            email = Notifier.create_directorate_key(@user, @login_url)
            Notifier.deliver(email)
            @user.reminded_on = Time.now
            @user.save
          when 'ProjectManager'
            email = Notifier.create_project_key(@user, @login_url)
            Notifier.deliver(email)
            @user.reminded_on = Time.now
            @user.save
          when 'ActivityApprover'
            email = Notifier.create_approver_key(@user, @login_url)
            Notifier.deliver(email)
            @user.reminded_on = Time.now
            @user.save
        end
      end
      log_event('Remind', %Q[A passkey reminder was sent to <a href="mailto:#{@user.email}">#{@user.email}</a>.])
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
  end

  # Send a passkey reminder to the email associated with this user. Only one e-mail will be sent and
  # it will use the Organisation Manager or Activity Manager template accordingly.
  # The system currently does not allow for a user to be both types of manager. If it did, this would not work.
  # TODO: check the logic associated with this, see also: User#new_link
  # Available to: Administrator
  #               Organisation Manager
  def remind
    @user = User.find(params[:id])
    @login_url = @user.url_for_login(request)

    # Are they a activity manager?
    case @user.class.name
    when 'ActivityManager'
      email = Notifier.create_activity_key(@user, @login_url)
      flash[:notice] = 'Reminder for ' + @user.activity.name + ' sent to ' + @user.email
    when 'DirectorateManager'
      email = Notifier.create_directorate_key(@user, @login_url)
      flash[:notice] = 'Reminder for ' + @user.directorate.name + ' sent to ' + @user.email
    when 'ProjectManager'
      email = Notifier.create_project_key(@user, @login_url)
      flash[:notice] = 'Reminder for ' + @user.project.name + ' sent to ' + @user.email
    # Nope, are they an organisation manager?
    when 'OrganisationManager'
      email = Notifier.create_organisation_key(@user, @login_url)
      flash[:notice] = "Reminder for #{@user.organisation.name} sent to #{@user.email}"
    when 'ActivityApprover'
      email = Notifier.create_approver_key(@user, @login_url)
      flash[:notice] = 'Noification to submission for approval of ' + @user.activity.name + ' sent to ' + @user.email
    # Nope. Well do nothing then.
    else
      # Shouldn't get here - but let them know what happened anyway
      # TODO: throw exception in dev mode?
      flash[:notice] = 'No reminder e-mail sent. This user does not manage anything.'
      redirect_to :back
    end

    # Send the reminder e-mail
    log_event('Remind', %Q[A passkey reminder was sent to <a href="mailto:#{@user.email}">#{@user.email}</a>.])
    Notifier.deliver(email)
    # Update the time we reminded them
    @user.reminded_on = Time.now
    @user.save

    redirect_to :back
  end

  # Log the user in and then direct them to the right place based on the user type
  # Available to: anybody
  def login  
    passkey_param = params[:passkey]

    # Passkeys that end in an i shouldn't leave any audit trail
    if passkey_param[-1,1] == 'i'
      secret = true
      passkey = passkey_param[0,passkey_param.length-1]
    else
      secret = false
      passkey = passkey_param
    end
    
    user = User.find_by_passkey(passkey)
    if user.nil? # the key is not in the user table
      flash[:notice] = 'Out of date link, enter your email to receive a new one'
      redirect_to :action => 'index'
    else # the key is in the table so stash the user
      session[:user_id] = user.id
      
      # Store the secret status, to be paid attention to by the activity loggers
      session[:secret] = secret
      
      # Log the log-in event
      case user.class.name
        when 'ActivityManager'
          log_event('Login', %Q[<a href="mailto:#{user.email}">#{user.email}</a>, activity manager of <strong>#{user.activity.name}</strong> for <strong>#{user.activity.organisation.name}</strong> logged in.])
          redirect_to :controller => 'activities', :action => 'index'
        when 'ActivityApprover'
          log_event('Login', %Q[<a href="mailto:#{user.email}">#{user.email}</a>, activity approver for <strong>#{user.activity.name}</strong>, <strong>#{user.activity.organisation.name}</strong> logged in.])
          redirect_to :controller => 'activities', :action => 'show'
        when 'DirectorateManager'
          log_event('Login', %Q[<a href="mailto:#{user.email}">#{user.email}</a>, directorate manager of <strong>#{user.directorate.name}</strong> logged in.])
          redirect_to :controller => 'activities', :action => 'summary'
        when 'ProjectManager'
          log_event('Login', %Q[<a href="mailto:#{user.email}">#{user.email}</a>, project manager of <strong>#{user.project.name}</strong> logged in.])
          redirect_to :controller => 'activities', :action => 'summary'
        when 'OrganisationManager'
          log_event('Login', %Q[<a href="mailto:#{user.email}">#{user.email}</a>, organisation manager of <strong>#{user.organisation.name}</strong> logged in.])
          redirect_to :controller => 'activities', :action => 'summary'
        when 'Administrator'
          redirect_to organisations_url
        when 'ActivityCreator'
          log_event('Login', "The activity creation screen for #{user.organisation.name} was viewed")
          redirect_to :controller => 'activities', :action => 'signup'
      end
    end
  end

  def keys
    return unless DEV_MODE
    @administrators = Administrator.find(:all)
    @organisations = Organisation.find(:all)
    @organisation_managers = OrganisationManager.find(:all, :include => {:organisation => {:activities => :activity_manager}})
    @directorate_managers = DirectorateManager.find(:all)
    render :layout => 'keys'
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
