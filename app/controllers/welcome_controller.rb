#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class WelcomeController < ApplicationController
  layout "application"
  
  def index
  end
#
# Find the user and then send them a new key
# 
# Unlike controllers from Action Pack, the mailer instance doesn‘t 
# have any context about the incoming request.  So the request is 
# passed in explicitly
#
# I should probably check that the subdomain is correct as well,
# but who can be bothered with that.
#
  def new_link 
    @users = User.find_all_by_email(params[:email])
    if @users.empty? 
      flash[:notice] = 'Unknown Email'
    else
      for @user in @users
        new_passkey(@user)
        case @user.user_type
          when User::FUNCTIONAL
            email = Notifier.create_function_key(@user, request)
            Notifier.deliver(email)
           when User::ORGANISATIONAL
            email = Notifier.create_organisation_key(@user, request)
            Notifier.deliver(email)
          when User::ADMINISTRATIVE
            email = Notifier.create_administration_key(@user, request)
            Notifier.deliver(email)
        end
      end
      flash[:notice] = 'New link' + (@users.length >= 2 ? 's' :'') + ' sent to ' + @user.email 
    end
    redirect_to :action => 'index'
  end
#
# Log the user in and then direct them to the right place based on the
# user_type
# 
# TODO: Ensure that the subdomain matches the one expected for that user.
# 
# TODO: Monitor for repeated log ins from the same IP, block the IP if it
# looks like some kind of brute force attack.
#
  def login
    @user = User.find_by_passkey(params[:passkey])
    if @user.nil? # the key is not in the user table
      flash[:notice] = 'Out of date link, enter your email to recieve a new one'
      redirect_to :action => 'index'
    else # the key is in the table so stash the user
      @session['logged_in_user'] = @user
      case @user.user_type
        when User::FUNCTIONAL
          redirect_to :controller => 'function', :action => 'show', :id => 1
        when User::ORGANISATIONAL
          redirect_to :controller => 'function', :action => 'list'
        when User::ADMINISTRATIVE
          redirect_to :controller => 'organisation', :action => 'index'
      end
    end
  end

protected
#
# No methods are secured because this is an entirely public page.
#
  def secure?
    false
  end  
  
private
#
# Give the user a new key
#
  def new_passkey(user)
    @user.passkey = User.new_passkey
    @user.reminded_on = Time.now
    @user.save
  end
end
