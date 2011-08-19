class PasswordsController < Devise::PasswordsController 
  # POST /resource/password
  
  def edit
    resource = User.find_by_reset_password_token(params[:reset_password_token])
    if resource
      resource.reset_password!
      set_flash_message(:notice, :updated) if is_navigational_format?
      redirect_to login_path
    else
      redirect_to access_denied_path
    end
  end
  
end