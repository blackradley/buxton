# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :authenticate
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_buxton_session_id'
  
  # Date formats
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
    :default => "%m/%d/%Y %H:%M",
    :date_time12 => "%d %b %Y %I:%M%p",
    :date_time24 => "%d %b %Y %H:%M"
  )
  
  # add a starts with method to the string
  class String
    def startsWith str
      return self[0...str.length] == str
    end
  end

  protected
  # Override in controller classes that should require authentication
  def secure?
    false
  end

  private
  def authenticate
#    if secure? && session["person"].nil?
#      session["return_to"] = request.request_uri
#      redirect_to :controller => "auth" 
#      return false
#    end
  end
end
