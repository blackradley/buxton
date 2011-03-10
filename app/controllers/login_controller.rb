class LoginController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers

  # GET /resource/sign_in
  def new
    clean_up_passwords(build_resource)
    render_with_scope :new
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in)
    sign_in(resource_name, resource)
    redirect_location(resource_name, resource)
  end

  # GET /resource/sign_out
  def destroy
    signed_in = signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
    set_flash_message :notice, :signed_out if signed_in
  end
  
  def redirect_location(resource_name, resource)
    if current_user
      if current_user.activity_manager?
        redirect_to activities_path
      end
    else
      redirect_to login_path
    end
  end
  
  def signout_and_redirect
    
  end
end