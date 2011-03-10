class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :requires_admin
  
  def index
    @breadcrumb = [["User Administration"]]
    @users = User.live
  end
  
  def new
    @breadcrumb = [["User Administration", users_path], ["Add New User"]]
    @user = User.new
  end
  
  def edit
    @breadcrumb = [["User Administration", users_path], ["Edit User"]]
    @user = User.live.find(params[:id])
  end
  
  def create
    @breadcrumb = [["User Administration", users_path], ["Add New User"]]
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
    else
      render "new"
    end
  end
  
  def update
    @breadcrumb = [["User Administration", users_path], ["Edit User"]]
    @user = User.live.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to users_path
    else
      render "edit"
    end
  end
end
