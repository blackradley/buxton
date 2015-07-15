class PasswordExpiredController < Devise::PasswordExpiredController
  skip_before_filter :handle_password_change
  prepend_before_filter :authenticate_scope!, :only => [:show, :update]

  def show
    if not resource.nil? and resource.need_change_password?
      sign_out
      set_flash_message :notice, :reset_password
      redirect_to login_path
    else
      redirect_to after_sign_in_path_for(resource)
    end
  end

  private

  def scope
    resource_name.to_sym
  end

  def authenticate_scope!
    send(:"authenticate_#{resource_name}!")
    self.resource = send("current_#{resource_name}")
  end
end
