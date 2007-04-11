#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class UserController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@user_pages, @users = paginate :users, :per_page => 10
    @users = User.find_admins
  end

  def new
    @user = User.new
  end
#
# You can only create an administrative user, the other users have
# to be created in conjunction with the organisation or function
# that they will be responsible for.
#
  def create
    @user = User.new(params[:user])
    @user.user_type = 0#User.ADMINISTRATIVE
    @user.passkey = User.new_UUID
    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.passkey = User.new_UUID
    if @user.update_attributes(params[:user])
      flash[:notice] = @user.email + ' was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def remind
    @user = User.find(params[:id])
    @user.passkey = User.new_UUID
    @user.reminded_on = Time.now
    @user.save
    email = Notifier.create_administration_key(@user)
    Notifier.deliver(email)
    flash[:notice] = 'New key sent to ' + @user.email
    redirect_to :action => 'list'
  end
end
