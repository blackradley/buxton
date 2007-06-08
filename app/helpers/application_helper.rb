# 
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
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
# Get the organisation name can be determined based on the style used,
# this is probably the best approach since it ensures that the style
# and the organisation name stay in step.  Also the organisation name
# can be determined even if the user isn't logged on.  Finally it
# provides another line of security defence so during the log on
# and security checks you can confirm that the user and organisation
# match.
# 
# However, the demonstration surcomvents most of this.  The subdomains
# for the demonstration organisations and the styles are no longer 
# unique.  And the security has been largely removed because it is
# a demonstration.
#
  def organisation_name(request)
    begin
      # organisation_name_out = Organisation.find_by_style(subdomain(request)).name
      organisation_name_out = session['logged_in_user'].organisation.name
    rescue
      organisation_name_out = "Black Radley Limited"
    end
    return organisation_name_out
  end
#
# Display the users progress through the questions
#
  def progress_bar(percentage)
    html = "<table border='0' cellpadding='0' cellSpacing='0' bgColor='Red'>"
    html += "<tr title='" + percentage.to_s + "%'>"
    html += "<td width='100' class='bar'>" + image_tag('green.gif', :width => percentage, :height => 10, :title=> percentage.to_s + '%') + "</td>"
    html += "</tr>"
    html += "</table>"
  end
#
# Extend the date formats to include some British styley ones
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
