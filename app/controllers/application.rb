# 
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
# Filters added to this controller apply to all controllers in 
# the application.  Likewise, all the methods added will be 
# available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :authenticate
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_buxton_session_id'
  
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
