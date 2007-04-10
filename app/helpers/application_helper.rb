# 
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
# Methods added to this helper will be available to all 
# templates in the application.
# 
module ApplicationHelper
#
# I could use request.subdomains(0).first but it throws
# a wobbly if in the development environment because
# there is no subdomain on http://localhost:3000/
# 
  def subdomain(request)
    return request.host().split(/\s*\.\s*/)[0] 
  end
  
end
