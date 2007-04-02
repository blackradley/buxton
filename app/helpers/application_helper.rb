# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def ApplicationHelper.subdomain(request)
    return request.subdomains(0).first
  end
  
  def ApplicationHelper.UUID
    return ActiveRecord::Base.connection.select_one('select UUID()')['UUID()']
  end
  
end
