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
      html += '<li title="Organisation Control Page - Summary" class="selected">' + link_to('Summary', {:controller => 'functions', :action => 'summary', :id => organisation.id}) + '</li>'
      html += '<li title="Organisation Control Page - Functions">' + link_to('Functions', {:controller => 'functions', :action => 'list', :id => organisation.id}) + '</li>'
      html += '<li title="Organisation Control Page - Function - Purpose">' + link_to('Purpose', {:controller => 'sections', :action => 'list', :section => 'purpose', :id => organisation.id}) + '</li>'
      html += '<li title="Organisation Control Page - Function - Performance">' + link_to('Performance', {:controller => 'sections', :action => 'list', :section => 'performance', :id => organisation.id}) + '</li>'
      html += '</ul>'
    end
    return html
  end

# The percentage number of questions answered for section 1 (the relevance
# test).  Originally this was part of the model but it has to make use of
# the Strategy table as well, which was inconvenient from the model.  Also
# you could argue that the number of questions answered is an external and
# arbitary value not inherent in the model.  In a way it is something that 
# is calculated based on the model, which is what happens here.
# 
# To prevent rounding occuring during the calculation (which would happen
# because all the values are integers) the number of questions is given with
# a decimal place to make it a float.  This seems a bit naff to me, I think
# there should be a neater way, but Ruby isn't my strongest skill.
#
  def section_purpose_percentage_answered(function)     
    number_of_questions = 20.0 + function.organisation.strategies.count # decimal point prevents rounding
    questions_answered = function.existence_status > 0 ? 1 : 0
    questions_answered += function.impact_service_users > 0 ? 1 : 0
    questions_answered += function.impact_staff > 0 ? 1 : 0
    questions_answered += function.impact_supplier_staff > 0 ? 1 : 0
    questions_answered += function.impact_partner_staff > 0 ? 1 : 0
    questions_answered += function.impact_employees > 0 ? 1 : 0
    questions_answered += function.good_gender > 0 ? 1 : 0
    questions_answered += function.good_race > 0 ? 1 : 0
    questions_answered += function.good_disability > 0 ? 1 : 0
    questions_answered += function.good_faith > 0 ? 1 : 0
    questions_answered += function.good_sexual_orientation > 0 ? 1 : 0
    questions_answered += function.good_age > 0 ? 1 : 0
    questions_answered += function.bad_gender > 0 ? 1 : 0
    questions_answered += function.bad_race > 0 ? 1 : 0
    questions_answered += function.bad_disability > 0 ? 1 : 0
    questions_answered += function.bad_faith > 0 ? 1 : 0
    questions_answered += function.bad_sexual_orientation > 0 ? 1 : 0
    questions_answered += function.bad_age > 0 ? 1 : 0
    questions_answered += function.approved.to_i 
    questions_answered += function.approver.blank? ? 0 : 1
    function.function_strategies.each do |strategy|
      questions_answered += strategy.strategy_response > 0 ? 1 : 0
    end
    percentage = (questions_answered / number_of_questions) * 100 # calculate
    percentage = percentage.round # round to one decimal place
    return percentage
  end
    
end
