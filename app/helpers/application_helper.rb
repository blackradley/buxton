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
  def progress_bar(percentage, width=nil, height=nil)
    options = {:controller => 'generate', :action => 'bar', :id => percentage}
    if width then options.store(:width, width) end
    image_tag(url_for(options))
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
          html = 'Logged in as a Function Manager'
        when User::TYPE[:organisational]
          html = 'Logged in as an Organisation Manager'
        when User::TYPE[:administrative]
          html = 'Logged in as an Administration Manager'
      end
    end
    return html
  end
#   
# Takes a list of links and generates a menu accordingly.
# On state provided by introduction of class="selected"
#   
  def generate_menu(links)
    link_html = ''
    links.each do |link|
      class_name = (current_page?(link[:url])) ? 'selected' : ''
      link_html << content_tag('li', link_to(link[:text], link[:url], :title => link[:title]),
        { :class => class_name })
    end
    content_tag('ul', link_html, :id => 'menuBar')
  end
#
# Display a coloured bar showing the level selected, produced 
# entirely via div's courtessy of Sam.
# 
  def level_bar(value, out_of, css_class)
    html = 'Not answered yet'
    if value != 0
      percentage = (value.to_f / (out_of.length - 1)) * 100.0
      percentage = percentage.round
      html = progress_bar(percentage)
    end
    return html
  end
#
# Shows a menu bar. Different for different user types. 
#
  def menu()
    user = session['logged_in_user']
    if user.nil?
      ' '
    elsif user.user_type == User::TYPE[:organisational]
      organisation = user.organisation
      generate_menu( [
                      { :text => 'Summary',
                        :url => { :controller => 'functions', :action => 'summary' },
                        :title => 'Organisation Control Page - Summary' },
                      { :text => 'Functions',
                        :url => { :controller => 'functions', :action => 'list' },
                        :title => 'Organisation Control Page - Functions' },
                      { :text => 'Purpose',
                        :url => { :controller => 'sections', :action => 'list', :id => 'purpose' },
                        :title => 'Organisation Control Page - Section - Purpose' },
                      { :text => 'Performance',
                        :url => { :controller => 'sections', :action => 'list', :id => 'performance' },
                        :title => 'Organisation Control Page - Section - Performance' }
                      ])
    elsif user.user_type == User::TYPE[:functional]
      function = user.function
      generate_menu( [
                      { :text => 'Overview',
                        :url => { :controller => 'functions', :action => 'overview'},
                        :title => 'Function Control Page - Overview' },
                      { :text => 'Summary',
                        :url => { :controller => 'functions', :action => 'show' },
                        :title => 'Function Control Page - Summary' }
                      ])
    else
      'Menu Fail'
    end
    

    
  end
  
#generates stand nav bar
def strandmenu()
  if params[:equalityStrand].nil?
    ''
  elsif params[:equalityStrand]=='overall'
       html = '<div id="strand">'
       html << params[:equalityStrand] 
       html << " : " 
       
       if params[:id]=='purpose'
         html << link_to ('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => 'selected')
			 else
			   html << link_to ('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => '')
       end
       
        html << ' >> '
        
       if params[:id]=='performance'
            html << link_to ('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => 'selected')
   		  else
   			   html << link_to ('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => '')
       end
       
        html << ' >> '
        
       if params[:id]=='confidence_information'
          html << link_to ('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => 'selected')
     		else
     			html << link_to ('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => '')
      end 
        
				html << "</div>"
		return html
    
  else
     html = '<div id="strand">'
     html << params[:equalityStrand] 
     html << " : " 
     
     if params[:id]=='purpose'
       html << link_to ('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => 'selected')
		 else
		   html << link_to ('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => '')
     end
     
      html << ' >> '
      
     if params[:id]=='performance'
          html << link_to ('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => 'selected')
 		  else
 			   html << link_to ('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => '')
     end
     
      html << ' >> '
      
     if params[:id]=='confidence_information'
        html << link_to ('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => 'selected')
   		else
   			html << link_to ('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => '')
    end 
    
      html << ' >> '
      
     if params[:id]=='confidence_consultation'
        html << link_to ('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Consultation', :class => 'selected')
   		else
   			html << link_to ('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Consultation', :class => '')
    end
    
    html << ' >> '
    
   if params[:id]=='additional_work'
      html << link_to ('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equalityStrand => params[:equalityStrand] }, :title => 'Additional Work', :class => 'selected')
 		else
 			html << link_to ('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equalityStrand => params[:equalityStrand] }, :title => 'Additional Work', :class => '')
  end
 
   html << ' >> '
    
   if params[:id]=='action_planning'
      html << link_to ('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equalityStrand => params[:equalityStrand] }, :title => 'Action Planning', :class => 'selected')
 		else
 			html << link_to ('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equalityStrand => params[:equalityStrand] }, :title => 'Action Planning', :class => '')
  end   
    
			html << "</div>"
			
	return html
  end
end
# Generates all the HTML needed to display the answer to a question
def answer(function, question)

  # Get the label text for this question
  label = $questions[question][0]

  # Get the answer options for this question and make an appropriate input field
  answer = case $questions[question][1]
  when :existing_proposed
    LookUp.existing_proposed.find{|lookUp| function.send(question) == lookUp.value}.name
  when :impact_amount
    LookUp.impact_amount.find{|lookUp| function.send(question) == lookUp.value}.name
  when :impact_level
    LookUp.impact_level.find{|lookUp| function.send(question) == lookUp.value}.name
  when :rating
    LookUp.rating.find{|lookUp| function.send(question) == lookUp.value}.name
  when :yes_no_notsure
    LookUp.yes_no_notsure.find{|lookUp| function.send(question) == lookUp.value}.name
  when :text
    function.send(question)
  when :string
    function.send(question)
  end

  %Q[<p><label title="#{label}">#{label}</label><div class="labelled">#{answer}</div></p>]
end
  
#
# Hash of questions (used in various places)
#
  $questions = {
    # Purpose questions
    :existence_status => ['Is the Function/Policy?', :existing_proposed],
    :impact_service_users => ['Service users', :impact_amount],
    :impact_staff => ['Staff employed by the council', :impact_amount],
    :impact_supplier_staff => ['Staff of supplier organisations', :impact_amount],
    :impact_partner_staff => ['Staff of partner organisations', :impact_amount],
    :impact_employees => ['Employees of businesses', :impact_amount],
    :good_age => ['Would it affect different <strong>age groups</strong> differently?', :impact_level],
    :good_race => ['Would it affect different <strong>Ethnic groups</strong> differently?', :impact_level],
    :good_gender => ['Would it affect <strong>men and women</strong> differently?', :impact_level],
    :good_sexual_orientation => ['Would it affect people of different <strong>sexual orientation</strong> differently?', :impact_level],
    :good_faith => ['Would it affect different <strong>faith groups</strong> differently?', :impact_level],
    :good_disability => ['Would it affect <strong>people with different kinds of disabilities</strong> differently?', :impact_level],
    :bad_age => ['Would it affect different <strong>age groups</strong> differently?', :impact_level],
    :bad_race => ['Would it affect different <strong>Ethnic groups</strong> differently?', :impact_level],
    :bad_gender => ['Would it affect <strong>men and women</strong> differently?', :impact_level],
    :bad_sexual_orientation => ['Would it affect people of different <strong>sexual orientation</strong> differently?', :impact_level],
    :bad_faith => ['Would it affect different <strong>faith groups</strong> differently?', :impact_level],
    :bad_disability => ['Would it affect <strong>people with different kinds of disabilities</strong> differently?', :impact_level],
    # Performance questions
    :overall_performance => ['How would you rate the current performance of the Function?', :rating],
    :overall_validated => ['Has this performance been validated?', :yes_no_notsure],
    :overall_validation_regime => ['Please note the validation regime:', :string],
    :overall_issues => ['Are there any performance issues which might have implications for different individuals within equality groups?', :yes_no_notsure],
    :overall_note_issues => ['Please note any such performance issues:', :text],
    :gender_performance => ['How would you rate the current performance of the Function in meeting the different needs of men and women?', :rating],
    :gender_validated => ['Has this performance been validated?', :yes_no_notsure],
    :gender_validation_regime => ['Please note the validation regime:', :string],
    :gender_issues => ['Are there any performance issues which might have implications for men or women?', :yes_no_notsure],
    :gender_note_issues => ['Please note any such performance issues:', :text],
    :race_performance => ['How would you rate the current performance of the Function in meeting the needs of people from different ethnic backgrounds?', :rating],
    :race_validated => ['Has this performance been validated?', :yes_no_notsure],
    :race_validation_regime => ['Please note the validation regime:', :string],
    :race_issues => ['Are there any performance issues which might have implications for people from different ethnic backgrounds?', :yes_no_notsure],
    :race_note_issues => ['Please note any such performance issues:', :text],
    :disability_performance => ['How would you rate the current performance of the Function in meeting the needs of people with different kinds of disability?', :rating],
    :disability_validated => ['Has this performance been validated?', :yes_no_notsure],
    :disability_validation_regime => ['Please note the validation regime:', :string],
    :disability_issues => ['Are there any performance issues which might have implications for people with different kinds of disability?', :yes_no_notsure],
    :disability_note_issues => ['Please note any such performance issues:', :text],
    :faith_performance => ['How would you rate the current performance of the Function in meeting the needs of people from different faith groups?', :rating],
    :faith_validated => ['Has this performance been validated?', :yes_no_notsure],
    :faith_validation_regime => ['Please note the validation regime:', :string],
    :faith_issues => ['Are there any performance issues which might have implications for people from different faith groups?', :yes_no_notsure],
    :faith_note_issues => ['Please note any such performance issues:', :text],
    :sexual_orientation_performance => ['How would you rate the current performance of the Function in meeting the needs of people of different sexual orientations?', :rating],
    :sexual_orientation_validated => ['Has this performance been validated?', :yes_no_notsure],
    :sexual_orientation_validation_regime => ['Please note the validation regime:', :string],
    :sexual_orientation_issues => ['Are there any performance issues which might have implications for people of different sexual orientations?', :yes_no_notsure],
    :sexual_orientation_note_issues => ['Please note any such performance issues:', :text],
    :age_performance => ['How would you rate the current performance of the Function in meeting the needs of people of different ages?', :rating],
    :age_validated => ['Has this performance been validated?', :yes_no_notsure],
    :age_validation_regime => ['Please note the validation regime:', :string],
    :age_issues => ['Are there any performance issues which might have implications for people of different ages?', :yes_no_notsure],
    :age_note_issues => ['Please note any such performance issues:', :text],
  }
end
