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
                        :title => 'Organisation Control Page - Section - Performance' },
                      { :text => 'Confidence Information',
                        :url => { :controller => 'sections', :action => 'list', :id => 'confidence_information' },
                        :title => 'Organisation Control Page - Section - Confidence Information' },
                      { :text => 'Confidence Consultation',
                        :url => { :controller => 'sections', :action => 'list', :id => 'confidence_consultation' },
                        :title => 'Organisation Control Page - Section - Confidence Consultation' },
                      { :text => 'Additional Work',
                        :url => { :controller => 'sections', :action => 'list', :id => 'additional_work' },
                        :title => 'Organisation Control Page - Section - Additional Work' },
                      { :text => 'Action Planning',
                        :url => { :controller => 'sections', :action => 'list', :id => 'action_planning' },
                        :title => 'Organisation Control Page - Section - Action Planning' }
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
         html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => 'selected')
			 else
			   html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => '')
       end
       
        html << ' >> '
        
       if params[:id]=='performance'
            html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => 'selected')
   		  else
   			   html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => '')
       end
       
        html << ' >> '
        
       if params[:id]=='confidence_information'
          html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => 'selected')
     		else
     			html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => '')
      end 
        
				html << "</div>"
		return html
    
  else
     html = '<div id="strand">'
     html << params[:equalityStrand].capitalize 
     html << " : " 
     
     if params[:id]=='purpose'
       html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => 'selected')
		 else
		   html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Purpose', :class => '')
     end
     
      html << ' >> '
      
     if params[:id]=='performance'
          html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => 'selected')
 		  else
 			   html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Performance', :class => '')
     end
     
      html << ' >> '
      
     if params[:id]=='confidence_information'
        html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => 'selected')
   		else
   			html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Information', :class => '')
    end 
    
      html << ' >> '
      
     if params[:id]=='confidence_consultation'
        html << link_to('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Consultation', :class => 'selected')
   		else
   			html << link_to('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equalityStrand => params[:equalityStrand] }, :title => 'Edit Confidence Consultation', :class => '')
    end
    
    html << ' >> '
    
   if params[:id]=='additional_work'
      html << link_to('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equalityStrand => params[:equalityStrand] }, :title => 'Additional Work', :class => 'selected')
 		else
 			html << link_to('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equalityStrand => params[:equalityStrand] }, :title => 'Additional Work', :class => '')
  end
 
   html << ' >> '
    
   if params[:id]=='action_planning'
      html << link_to('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equalityStrand => params[:equalityStrand] }, :title => 'Action Planning', :class => 'selected')
 		else
 			html << link_to('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equalityStrand => params[:equalityStrand] }, :title => 'Action Planning', :class => '')
  end   
    
			html << "</div>"
			
	return html
  end
end
# Generates all the HTML needed to display the answer to a question
def answer(function, section, strand, number)

  # Get the label text for this question
  label = function.question_wording_lookup(section, strand,number)[0]
  question="#{section}_#{strand}_#{number}"

  # Get the answer options for this question and make an appropriate input field
  unless function.send(question).nil?
    answer = case function.question_wording_lookup(section, strand,number)[1]
    when :existing_proposed
      LookUp.existing_proposed.find{|lookUp| function.send(question) == lookUp.value}.name
    when :function_policy
      LookUp.function_policy.find{|lookUp| function.send(question) == lookUp.value}.name
    when :impact_amount
      LookUp.impact_amount.find{|lookUp| function.send(question) == lookUp.value}.name
    when :impact_level
      LookUp.impact_level.find{|lookUp| function.send(question) == lookUp.value}.name
    when :rating
      LookUp.rating.find{|lookUp| function.send(question) == lookUp.value}.name
    when :yes_no_notsure
      LookUp.yes_no_notsure.find{|lookUp| function.send(question) == lookUp.value}.name
    when :timescales
      LookUp.timescales.find{|lookUp| function.send(question) == lookUp.value}.name
    when :consult_groups
      LookUp.consult_groups.find{|lookUp| function.send(question) == lookUp.value}.name
    when :consult_experts
      LookUp.consult_experts.find{|lookUp| function.send(question) == lookUp.value}.name
    when :text
      function.send(question)
    when :string
      function.send(question)
    end
  else
    answer = ''
  end

  %Q[<p><label title="#{label}">#{label}</label><div class="labelled">#{answer}</div></p>]
end

  def summary_answer(function, section, strand, number)
     label = function.question_wording_lookup(section, strand,number)[0]
     question="#{section}_#{strand}_#{number}"

     barImage = level_bar(function.send(question), LookUp.impact_amount, 'bar-impact-groups')

         # Show our formatted question!
         %Q[<p>
         <label title="#{label}">#{label}</label>
         <div class="labelled">#{barImage}</div>
         </p>]
         #%Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
   end
end
