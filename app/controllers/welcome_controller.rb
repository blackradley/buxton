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
  def new_key 
    @users = User.find_all_by_email(params[:email])
    if @users.empty? 
      flash[:notice] = 'Unknown Email'
    else
      for @user in @users
        rekey_user(@user)
        case @user.user_type
          when User::FUNCTIONAL
            email = Notifier.create_function_key(@user, request)
            Notifier.deliver(email)
            flash[:notice] = 'New function key sent to ' + @user.email 
          when User::ORGANISATIONAL
            email = Notifier.create_organisation_key(@user, request)
            Notifier.deliver(email)
            flash[:notice] = 'New organisation key sent to ' + @user.email
          when User::ADMINISTRATIVE
            email = Notifier.create_administration_key(@user, request)
            Notifier.deliver(email)
            flash[:notice] = 'New administration key sent to ' + @user.email
        end
      end
    end
    redirect_to :action => 'index'
  end
  
private
#
# Give the user a new key
#
  def rekey_user(user)
    @user.passkey = User.new_UUID
    @user.reminded_on = Time.now
    @user.save
  end
end
