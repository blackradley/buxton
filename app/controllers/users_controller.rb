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
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    # Log out the user if they are logged in
    logout()
  end

  def list
    @users = User.find_admins
  end

  def new
    @user = User.new
  end

  # You can only create an administrative user, the other users have
  # to be created in conjunction with the organisation or function
  # that they will be responsible for.
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

  def edit
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render :inline => 'Invalid ID.'  
  end

  # Disabled - Give the user a new key every time it is updated
  # TODO: check whether this should be enabled
  def update
    @user = User.find(params[:id])
    # @user.passkey = User.new_passkey # TODO: check whether this should be enabled
    if @user.update_attributes(params[:user])
      flash[:notice] = @user.email + ' was successfully updated.'
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
  # I should probably check that the subdomain is correct as well,
  # but who can be bothered with that.
  #
  # TODO: I am not sure that this actually works, check that if you have
  # a user that is operational user and a number of functional users, do
  # the links actually match up with the functions.
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
      flash[:notice] = 'New link' + (@users.length >= 2 ? 's' :'') + ' sent to ' + @user.email
    end
    redirect_to :action => 'index'
  end

  # Destroy the user
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

  # Log the user in and then direct them to the right place based on the
  # user_type
  #
  # TODO: Ensure that the subdomain matches the one expected for that user.
  #
  # TODO: Monitor for repeated log ins from the same IP, block the IP if it
  # looks like some kind of brute force attack.
  #
  # TODO: Expire the keys after 10 days.
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

  def demo
    # Log out the user if they are logged in
    logout()
  end

  # Create a new user and organisation, then log the user in.  Obviously this
  # bypasses the minimal security, but it is just a demo.  If the user is already
  # an organisational user the they go straight to the login.  So we don't get
  # multiple demo organisations for the same user.
  #
  # If an admin user requests a demo then one is created for them since the
  # admin users are not sought in the first find.
  def create_demo
    @user = User.find(:first, :conditions => {:email => params[:email], :user_type => User::TYPE[:organisational]})
    organisational_user_passkey = nil # the passkey will have to be retained for the organisational user.
    if @user.nil?
      Function.transaction do
        Strategy.transaction do
          Organisation.transaction do
            User.transaction do
              # Create a new user
              @user = User.new
              @user.email = params[:email]
              @user.user_type = User::TYPE[:organisational]
              @user.passkey = User.generate_passkey(@user)
              @user.save!
              organisational_user_passkey = @user.passkey
              # Give the user an organisation
              @organisation = Organisation.new
              @organisation.user = @user
              @organisation.name = 'Demo Council'
              @organisation.style = 'www'
              @organisation.save!
              # Give the organisation some strategies
              strategy_names = ['Manage resources effectively, flexibly and responsively',
                'Investing in our staff to build an organisation that is fit for its purpose',
                'Raising performance in our services for children, young people, families and adult',
                'Raising performance in our housing services',
                'Cleaner, greener and safer environment',
                'Investing in regeneration',
                'Improving our transport and tackling congestion',
                'Providing more effective education and leisure opportunities']
              strategy_names.each {|strategy_name|
                strategy = Strategy.new
                strategy.organisation = @organisation
                strategy.name = strategy_name
                strategy.description = strategy_name
                strategy.display_order = 0
                strategy.save!
              }
              # Give the organisation three functions which are owned by the same user
              function_names = ['Community Strategy', 'Publications', 'Meals on Wheels']
              function_names.each {|function_name|
                @user = User.new
                @user.email = params[:email]
                @user.user_type = User::TYPE[:functional]
                @user.passkey = User.generate_passkey(@user)                
                @user.save
                function = Function.new
                function.user = @user
                function.organisation = @organisation
                function.name = function_name
                function.save!
              }
            end
          end
        end
      end
    else
      organisational_user_passkey = @user.passkey
    end
    flash[:notice] = 'Demonstration organisation was created.'
    # Log in the organisational version of the user.
    redirect_to :action => :login, :passkey => organisational_user_passkey
    rescue ActiveRecord::RecordInvalid => invalid
      @user.valid?
      render :action => :demo
  end

protected
  # No methods are secure
  # TODO: secure the methods that need it, or alternatively white-list them instead
  def secure?
    false
  end
  
  # Log the user out of the system by killing the session parameter that identifies them as being logged in
  def logout
    session[:user_id] = nil    
  end  
end