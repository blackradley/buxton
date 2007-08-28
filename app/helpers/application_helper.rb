#
# $URL$
#
# $Rev$
#
# $Author$
#
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# Methods added to this helper will be available to all templates in the application.
#
module ApplicationHelper
#
# I could use <tt>request.subdomains(0).first</tt> but it throws a wobbly if in
# the development environment because there is no subdomain on http://localhost:3000/
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
# However, the demonstration circumvents most of this.  The subdomains
# for the demonstration organisations and the styles are no longer
# unique.  And the security has been largely removed because it is
# a demonstration.
#
  def organisation_name(request)
    begin
      if subdomain(request) == 'www' # it is probably a demo
        organisation_name_out = session['logged_in_user'].organisation.name
      else # it is a specifically set up organisation
        organisation_name_out = Organisation.find_by_style(subdomain(request)).name
      end
    rescue
      organisation_name_out = ''
    end
    return organisation_name_out
  end
#
# Display the users progress through the questions, this is used both in the
# Function and on the Organisation, hence it is here in the ApplicationHelper.
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
# Format the date or say there is nothing, rather than just outputting
# a blank or the date from the begining of the epoch.
#
  def date_or_blank(date)
    if date.nil?
      return 'no date'
    else
      return date.to_formatted_s(:date_time12)
    end
  end
#
# Show the logged in user type.
#
  def login_status()
    html = 'Login status unknown'
    user = session['logged_in_user']
    if user.nil?
      html = ''
    else
      case user.user_type
        when User::TYPE[:functional]
          html = 'You are logged in as Function Manager'
        when User::TYPE[:organisational]
          html = 'You are logged in as Organisation Manager'
        when User::TYPE[:administrative]
          html = 'You are logged in as Administration Manager'
      end
    end
    return html
  end
#
# Show a simple menu bar for the organisational user, but not for
# anyone else.
#
# TODO: I think of a better way of doing the menu.  This just seems
# terribly complicated to me.
#
  def menu_bar()
    html = 'Menu Fail'
    user = session['logged_in_user']
    if user.nil?
      html = 'Menu Not logged in'
    elsif user.user_type == User::TYPE[:organisational]
      organisation = user.organisation
      html = '<ul class="menuBar">'
      html += '<li title="Organisation Control Page - Summary">' + link_to('Summary', {:controller => 'function', :action => 'summary', :id => organisation.id}, :id => 'summary') + '</li>'
      html += '<li title="Organisation Control Page - Functions">' + link_to('Functions', {:controller => 'function', :action => 'list', :id => organisation.id}, :id => 'list') + '</li>'
      html += '<li title="Organisation Control Page - Function - Purpose">' + link_to('Purpose', {:controller => 'function', :action => 'list1', :id => organisation.id}, :id => 'list1') + '</li>'
      html += '<li title="Organisation Control Page - Function - Performance">' + link_to('Performance', {:controller => 'function', :action => 'list2', :id => organisation.id}, :id => 'list2') + '</li>'
      html += '</ul>'
    end
    return html
  end
end
