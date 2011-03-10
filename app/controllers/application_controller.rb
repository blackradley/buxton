class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include HoptoadNotifier::Catcher
  helper :all # include all helpers, all the time

  include AccessSystem
  include SecurityModelHelper

  # before_filter :authenticate
  before_filter :set_current_user
  before_filter :set_banner if BANNER

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from NoMethodError, :with => :wrong_user? unless DEV_MODE

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => '370c47b86a8ff547b2b472693b0980a4'  

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



  # If the user_id session variable exists, grab this user from the database and store
  # in @current_user making it available to the action of any controller.
  def set_current_user
    @current_user = current_user
  end
  
  def set_banner
    @banner_text = "Not live. You are on a server in #{RAILS_ENV} mode."

    revision_file = File.join(RAILS_ROOT, 'REVISION')
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
    render :file => "#{RAILS_ROOT}/public/404.html",  :status => "404 Not Found"
  end
  
  def requires_admin
    redirect_to access_denied_path unless current_user.is_a?(Administrator)
  end
  
  def access_denied_url
    '/users/access_denied'
  end
  
  def strand_display(strand)
    strand.to_s.downcase == 'faith' ? 'religion or belief' : strand
  end

  
private
  def set_activity
    @activity = @current_user.activity_manager_activities.find_by_id(params[:activity_id])
  end
end
