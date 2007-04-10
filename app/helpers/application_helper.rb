# Methods added to this helper will be available to all 
# templates in the application.
# 
# $Id: foo.bar 123 2006-02-02 08:40:12Z agorf $
module ApplicationHelper

  # I could use request.subdomains(0).first but it throws
  # a wobbly if in the development environment because
  # there is no subdomain on http://localhost:3000/
  def subdomain(request)
    return request.host().split(/\s*\.\s*/)[0] 
  end
  
  # Thers is no built in method for creating a GUID in Ruby
  # so the UUID in MySql is called instead.
  def newUUID
    return ActiveRecord::Base.connection.select_one('select UUID()')['UUID()']
  end
  
end
