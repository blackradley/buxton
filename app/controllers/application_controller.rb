class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :site_layout
  
  helper :all # include all helpers, all the time

  before_filter :set_current_user
  before_filter :set_banner if BANNER
  # rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  # rescue_from NoMethodError, :with => :wrong_user? unless DEV_MODE
  before_filter :authenticate_user!
  before_filter :check_trained
  before_filter :setup_menus
  alias_method :old_sign_out, :sign_out
  
  def set_homepage
    redirect_to after_sign_in_path_for(current_user)
  end


protected

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
  
  # def not_found
  #   render :file => "#{Rails.root}/public/404.html",  :status => "404 Not Found", :layout => false
  # end
  
  def requires_admin
    return if devise_controller?
    redirect_to access_denied_path unless user_signed_in? && current_user.is_a?(Administrator)
  end
  
  def after_sign_in_path_for(resource)
   return users_path if current_user.is_a?(Administrator)
   LoginLog.create(:user => current_user)
   #log_event('Login', %Q[<a href="mailto:#{current_user.email}">#{current_user.email}</a> logged in.])
   # return training_user_path(current_user) unless current_user.trained?
   unless @activities_menu.blank?
     return @activities_menu.first[1]
   else
    if current_user.creator?
      return directorates_path
    elsif current_user.is_a? Administrator
      return users_path
    end
   end
   return new_user_users_path
  end
  
  def strand_display(strand)
    if strand.to_s.downcase == 'faith'
      return 'religion or belief'
    elsif strand.to_s.downcase == 'marriage_civil_partnership'
      return 'marriage or civil partnership'
    else
      return strand
    end
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
    redirect_to access_denied_path unless current_user.corporate_cop? || current_user.directorate_cop? || current_user.creator?
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
  
  def ensure_task_group_member
    redirect_to access_denied_path unless current_user.helper?
  end
  
  def ensure_quality_control
    redirect_to access_denied_path unless current_user.quality_control?
  end
  
  def ensure_pdf_view
    redirect_to access_denied_path unless current_user.creator? || current_user.approver? || current_user.completer? || current_user.quality_control?
  end
  
  def sign_out(*args)
    if current_user && !current_user.is_a?(Administrator)
      LogoutLog.create(:user => current_user)
      #log_event('Logout', %Q[<a href="mailto:#{current_user.email}">#{current_user.email}</a> logged out.])
    end
    old_sign_out(*args)
  end
  
private

  def setup_menus
    menu = Array.new
    return [] unless current_user
    menu << ["EA Governance", directorate_governance_eas_activities_path] unless current_user.completer?
    current_user.roles.map do |role| 
      case role
      when "Completer"
        menu << ["Task Group Manager", my_eas_activities_path]
      when "Approver"
        menu << ["Awaiting Approval", approving_activities_path]
      when "Creator"
        if current_user.count_live_directorates > 0
          menu << ["Directorate EAs", directorate_eas_activities_path]
          if current_user.activities.size > 0
            menu << ["Actions", actions_activities_path]
          end
        end
      when "Quality Control"
        menu << ["Quality Control", quality_control_activities_path]
      when "Directorate Cop"
        menu << ["EA Governance", directorate_governance_eas_activities_path]
      when "Corporate Cop"
        menu << ["EA Governance", directorate_governance_eas_activities_path]
        menu << ["Activity Logging", logs_path]
      when "Helper"
        menu << ["Task Group Member", assisting_activities_path]
      end
    end
    @activities_menu = menu.uniq
  end
  
  
  def set_activity
    @activity = current_user.activities.select{|a| a.id == params[:activity_id].to_i}.first
  end
end
