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

  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])

    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with_navigational(resource){ render_with_scope :new }
    end
  end
  
end