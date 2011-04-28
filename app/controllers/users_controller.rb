class UsersController < ApplicationController
  before_filter :authenticate_user!# , :except => [:reset_password, :reset_password_request]
  skip_before_filter :check_trained
  before_filter :requires_admin, :except => [:training, :update_training, :access_denied]
  before_filter :setup_breadcrumb
  
  def index
    @users = User.live
  end
  
  def new
    @breadcrumb = [["User Administration", users_path], ["Add New User"]]
    @user = User.new
  end
  
  def edit
    @breadcrumb = [["User Administration", users_path], ["Edit User"]]
    @user = User.live.find(params[:id])
    if request.xhr?
      render :layout => false
    end
  end
  
  def create
    @breadcrumb = [["User Administration", users_path], ["Add New User"]]
    @user = User.new(params[:user].merge(:trained => true))
    if @user.save
      redirect_to users_path
    else
      render "new"
    end
  end
  

  
  def show
    redirect_to set_homepage
  end
  # 
  # def reset_password_request
  #   render :layout => "login"
  # end
  # 
  # def confirm_reset_password
  #   if params[:email] && @user = User.find_by_email(params[:email])
  #     @user.reset_password
  #     flash[:message] = "Password successfully reset. Please check your email to retrieve your new password"
  #   else
  #     flash[:error] = "The email address you entered was not recognised. Please try again."
  #   end
  #   redirect_to user_login_path
  # end


  def toggle_user_status
    @user = User.find(params[:id])
    @user.toggle(params[:checkbox])
    @user.save
    render :nothing => true
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
  
  def access_denied
  end
  
  def training
  end
  
  def update_training
    current_user.update_attributes(:trained => true)
    redirect_to root_path
  end

  private
  
  def setup_breadcrumb
    @breadcrumb = [["User Administration"]]
  end
end
