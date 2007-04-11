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
# 
# Add a starts with method to the string
#
  class String
    def startsWith str
      return self[0...str.length] == str
    end
  end
#
# Date formats
# 
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
    :default => "%m/%d/%Y %H:%M",
    :date_time12 => "%d %b %Y %I:%M%p",
    :date_time24 => "%d %b %Y %H:%M"
  )
#
# Format the date or say there is nothing
#
  def date_or_blank(date)
    if date.nil?
      return 'no date'
    else
      return date.to_formatted_s(:date_time12)
    end
  end
end
