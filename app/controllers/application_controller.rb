class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :site_layout
  
  helper :all # include all helpers, all the time

  before_filter :set_current_user
  before_filter :set_banner if BANNER
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from NoMethodError, :with => :wrong_user? unless DEV_MODE
  before_filter :authenticate_user!
  before_filter :check_trained
  alias_method :old_sign_out, :sign_out
  
  def set_homepage
    redirect_to after_sign_in_path_for(current_user)
  end


protected
  def log_event(type, text)
    # If this is a secret login, disable the creating of logs by returning false here
    return false if session[:secret]
    # e.g. Convert :PDF to PDFLog
    class_name = "#{type}Log"
    # Log this type of event
    # CAUTION! See: http://notetoself.vrensk.com/2008/08/escaping-single-quotes-in-ruby-harder-than-expected/
    # for why we're escaping this this way
    escaped_text = text.gsub(/\\|'/) { |c| "\\#{c}" }
    instance_eval("#{class_name}.create(:message => '#{escaped_text}')")
  end

  def site_layout
    devise_controller? ? "login" : "application"
  end


  # If the user_id session variable exists, grab this user from the database and store
  # in @current_user making it available to the action of any controller.
  def set_current_user
    @current_user = current_user
  end
  
  def set_banner
    @banner_text = "Not live. You are on a server in #{Rails.env} mode."

    revision_file = File.join(Rails.root.to_s, 'REVISION')
    if File.exists?(revision_file) then
      f = File.new(revision_file)
      @banner_text += " Revision: #{f.readline}."
    end
  end

  # Override in controller classes that should require authentication
  def secure?
    false
  end
  
  def not_found
    render :file => "#{Rails.root}/public/404.html",  :status => "404 Not Found"
  end
  
  def requires_admin
    return if devise_controller?
    redirect_to access_denied_path unless user_signed_in? && current_user.is_a?(Administrator)
  end
  
  def after_sign_in_path_for(resource)
   return users_path if current_user.is_a?(Administrator)
   log_event('Login', %Q[<a href="mailto:#{current_user.email}">#{current_user.email}</a> logged in.])
   return training_user_path(current_user) unless current_user.trained?
   return access_denied_path if current_user.roles.blank?
   return directorate_einas_activities_path if current_user.creator?
   return my_eas_activities_path if current_user.completer?
   return approving_activities_path if current_user.approver?
   return directorate_governance_eas_activities_path if current_user.directorate_cop? || current_user.corporate_cop?
   return access_denied_path
  end
  
  def strand_display(strand)
    strand.to_s.downcase == 'faith' ? 'religion or belief' : strand
  end

  def check_trained
    return if devise_controller?
    if user_signed_in? && !current_user.is_a?(Administrator)
      redirect_to training_user_path(current_user) and return unless current_user.trained?
    end
  end
  
  def ensure_creator
    redirect_to access_denied_path unless current_user.creator?
  end
  
  def ensure_cop
    redirect_to access_denied_path unless current_user.corporate_cop? || current_user.directorate_cop?
  end
  
  def ensure_corporate_cop
    redirect_to access_denied_path unless current_user.corporate_cop?
  end
  
  def ensure_completer
    redirect_to access_denied_path unless current_user.completer?
  end
  
  def ensure_approver
    redirect_to access_denied_path unless current_user.approver?
  end
  
  def ensure_pdf_view
    redirect_to access_denied_path unless current_user.creator? || current_user.approver? || current_user.completer?
  end
  
  def sign_out(*args)
    if current_user
      log_event('Logout', %Q[<a href="mailto:#{current_user.email}">#{current_user.email}</a> logged out.])
    end
    old_sign_out(*args)
  end
  
private

  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:activity_id].to_i}.first
  end
end
