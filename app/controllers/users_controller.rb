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
          :only => [ :destroy, :create, :update ],
          :render => { :text => '405 HTTP POST required.', :status => 405, :add_headers => { 'Allow' => 'POST' } }

  # Present a form to request a lost passkey by entering your e-mail address.
  # Available to: anybody
  def index
    # Log out the user if they are logged in
    logout()
  end

  # List all admins.
  # Available to: Administrator
  def list
    @users = User.find_admins
  end

  # New screen for a user.
  # Available to: Administrator
  def new
    @user = User.new
  end

  # You can only create an administrative user, the other users have
  # to be created in conjunction with the organisation or function
  # that they will be responsible for.
  # Available to: Administrator  
  def create
    @user = User.new(params[:user])
    @user.user_type = User::TYPE[:administrative]
    @user.passkey = User.generate_passkey(@user)
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => :new
    end
    rescue ActiveRecord::RecordInvalid => e
      @user.valid? # force checking of errors even if function failed
      render :action => :new
  end

  # Edit screen for a user.
  # Available to: Administrator  
  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render :inline => 'Invalid ID.'  
  end

  # Update a user's details.
  # [Disabled] Give the user a new key every time it is updated
  # TODO: check whether this should be enabled
  # Available to: Administrator
  def update
    @user = User.find(params[:id])
    # @user.passkey = User.new_passkey # TODO: check whether this should be enabled
    if @user.update_attributes(params[:user])
      flash[:notice] = "#{@user.email} was successfully updated."
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  rescue ActiveRecord::RecordNotFound => e
    render :inline => 'Invalid ID.'
  end

  # Find the user and then send them a new key
  #
  # Unlike controllers from Action Pack, the mailer instance doesn't
  # have any context about the incoming request. So the request is
  # passed in explicitly.
  #
  # TODO: I am not sure that this actually works, check that if you have
  # a user that is operational user and a number of functional users, do
  # the links actually match up with the functions.
  # 
  # Available to: anybody
  def new_link
    @users = User.find_all_by_email(params[:email])
    if @users.empty?
      flash[:notice] = 'Unknown Email'
    else
      for @user in @users
        # new_passkey(@user)
        case @user.user_type
          when User::TYPE[:functional]
            email = Notifier.create_function_key(@user, request)
            Notifier.deliver(email)
            @user.reminded_on = Time.now.gmtime
            @user.save
           when User::TYPE[:organisational]
            email = Notifier.create_organisation_key(@user, request)
            Notifier.deliver(email)
            @user.reminded_on = Time.now.gmtime
            @user.save
          when User::TYPE[:administrative]
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
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = 'User successfully deleted.'
    redirect_to :action => 'list'
  rescue ActiveRecord::RecordNotFound => e  
    render :inline => 'Invalid ID.'    
  end
  
  # Send a passkey reminder to the email associated with this user. Only one e-mail will be sent and
  # it will use the Organisation Manager or Function Manager template accordingly.
  # The system currently does not allow for a user to be both types of manager. If it did, this would not work.
  # TODO: check the logic associated with this, see also: User#new_link
  # Available to: Administrator
  #               Organisation Manager
  def remind
    @user = User.find(params[:id])
    
    # Are they a function manager?
    if @user.function then
      email = Notifier.create_function_key(@user, request)
      flash[:notice] = 'Reminder for ' + @user.function.name + ' sent to ' + @user.email
    # Nope, are they an organisation manager?
    elsif @user.organisation then
      email = Notifier.create_organisation_key(@user, request)
      flash[:notice] = 'Reminder for ' + @user.organisation.name + ' sent to ' + @user.email
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
  rescue ActiveRecord::RecordNotFound => e
    render :inline => 'Invalid ID.'    
  end

  # Log the user in and then direct them to the right place based on the user_type
  # Available to: anybody
  def login
    user = User.find_by_passkey(params[:passkey])
    if user.nil? # the key is not in the user table
      flash[:notice] = 'Out of date link, enter your email to receive a new one'
      redirect_to :action => 'index'
    else # the key is in the table so stash the user
      session[:user_id] = user.id
      case user.user_type
        when User::TYPE[:functional]
          if user.function.started then
            redirect_to :controller => 'functions', :action => 'show'
          else
           redirect_to :controller => 'functions', :action => 'status'
          end
        when User::TYPE[:organisational]
          redirect_to :controller => 'functions', :action => 'summary'
        when User::TYPE[:administrative]
          redirect_to :controller => 'organisations', :action => 'index'
      end
    end
  end

protected
  # No methods are secure
  def secure?
    false
  end
  
end