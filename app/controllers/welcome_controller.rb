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
  def new_key
    @users = User.find_all_by_email(params[:email])
    if @users.empty? 
      flash[:notice] = 'Unknown Email'
    else
      for user in @users
        case user.user_type
          when User::FUNCTIONAL
            
          when User::ORGANISATIONAL
            
          when User::ADMINISTRATIVE
            @user.passkey = User.new_UUID
            @user.reminded_on = Time.now
            @user.save
            email = Notifier.create_administration_key(@user)
            Notifier.deliver(email)
            flash[:notice] = 'New key sent to ' + @user.email
        end
      end
    end
    redirect_to :action => 'index'
  end
  
end
