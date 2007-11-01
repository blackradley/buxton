#
# $URL$
# $Rev$
# $Author$
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
    if percentage > 100 then percentage = 100 end
    case width
    when 100
      image_tag("bars/small/#{percentage}.png")
    else
      image_tag("bars/large/#{percentage}.png")
    end
    # options = {:controller => 'generate', :action => 'bar', :id => percentage}
    # if width then options.store(:width, width) end
    # image_tag(url_for(options))
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
                      { :text => 'Sections',
                        :url => { :controller => 'sections', :action => 'list' },
                        :title => 'Organisation Control Page - Sections' }
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
  
#generates strand nav bar
def strandmenu()
  if params[:equality_strand].nil?
    ''
  elsif params[:equality_strand]=='overall'
       html = '<div id="strand">'
       html << params[:equality_strand].capitalize 
       html << " : " 
       
       if params[:id]=='purpose'
         html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equality_strand => params[:equality_strand] }, :title => 'Edit Purpose', :class => 'selected')
			 else
			   html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equality_strand => params[:equality_strand] }, :title => 'Edit Purpose', :class => '')
       end
       
        html << ' >> '
        
       if params[:id]=='performance'
            html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equality_strand => params[:equality_strand] }, :title => 'Edit Performance', :class => 'selected')
   		  else
   			   html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equality_strand => params[:equality_strand] }, :title => 'Edit Performance', :class => '')
       end
       
        html << ' >> '
        
       if params[:id]=='confidence_information'
          html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Information', :class => 'selected')
     		else
     			html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Information', :class => '')
      end 
        
				html << "</div>"
		return html
    
  else
     html = '<div id="strand">'
     html << params[:equality_strand].gsub("_",  " ").capitalize 
     html << " : " 
     
     #      if params[:id]=='purpose'
     #        html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equality_strand => params[:equality_strand] }, :title => 'Edit Purpose', :class => 'selected')
     # else
     #   html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equality_strand => params[:equality_strand] }, :title => 'Edit Purpose', :class => '')
     #      end
     #      
     #       html << ' >> '
      
     if params[:id]=='performance'
          html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equality_strand => params[:equality_strand] }, :title => 'Edit Performance', :class => 'selected')
 		  else
 			   html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equality_strand => params[:equality_strand] }, :title => 'Edit Performance', :class => '')
     end
     
      html << ' >> '
      
     if params[:id]=='confidence_information'
        html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Information', :class => 'selected')
   		else
   			html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Information', :class => '')
    end 
    
      html << ' >> '
      
     if params[:id]=='confidence_consultation'
        html << link_to('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Consultation', :class => 'selected')
   		else
   			html << link_to('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Consultation', :class => '')
    end
    
    html << ' >> '
    
   if params[:id]=='additional_work'
      html << link_to('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equality_strand => params[:equality_strand] }, :title => 'Additional Work', :class => 'selected')
 		else
 			html << link_to('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equality_strand => params[:equality_strand] }, :title => 'Additional Work', :class => '')
  end
 
   html << ' >> '
    
   if params[:id]=='action_planning'
      html << link_to('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equality_strand => params[:equality_strand] }, :title => 'Action Planning', :class => 'selected')
 		else
 			html << link_to('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equality_strand => params[:equality_strand] }, :title => 'Action Planning', :class => '')
  end   
    
			html << "</div>"
			
	return html
  end
end

def sections_menu
  links = [
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
  ]
  generate_menu(links)
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


$help = {
	:performance => { 
	  :gender => {
      	1 => [
        	"<p>This question asks you to assess how well the Function is performing in meeting the needs of the different groups within an Equality Strand.  The available answers are on a five point scale from 5 excellent to 1 poor.  As before Not sure if also an acceptable answer.</p>
          <p>Please answer the question, identifying how well the Function is meeting the particular needs of men and women.  It may be that the Function is meeting the needs of women very effectively but is not meeting the needs of men.</p>
          <p>If the Function is not meeting the needs of either men or women because of their gender then the Function is not performing well for the Gender Equality Strand.</p>
          <p>If you are not sure whether the Function meets the particular needs of men and women please answer not sure.  This is a perfectly acceptable answer as it is not always clear whether a particular Function meets the particular needs of men and women.</p>"
          ],
    		2 => [
    		  "<p>The performance assessment in question 1 may have been confirmed or validated by either an internal or external inspection process.  Please answer the question to indicate whether this is the case and, if applicable, write the name of the relevant process in the text box.  Examples of the sort of thing you might include are a CPA finding or an OFSTED report.</p>"
    		  ],
    		4 => [
    		  "<p>The performance assessment in question 1 will provide the background to answering this question.  Please answer whether there are any performance issues which affect men or women because of their gender.  Please record any such issues in the text box.  Any issues recorded should arise because of the user’s gender, not just a general failing of the Function to meet user needs.</p>"
    		  ]
    },
    :race => {
      	1 => [
        	"<p>This question asks you to assess how well the Function is performing in meeting the needs of the different groups within an Equality Strand.  The available answers are on a five point scale from 5 excellent to 1 poor.  As before Not sure if also an acceptable answer.</p>
          <p>Please answer the question, identifying how well the Function is meeting the particular needs of people from different ethnic backgrounds.  It may be that the Function is meeting the needs of one ethnic group very effectively but is not meeting the needs of another.</p>
          <p>If the Function is not meeting the needs of any individuals from an ethnic group because of their ethnicity then the Function is not performing well for the Gender Equality Strand.</p>
          <p>If you are not sure whether the Function meets the particular needs of people from different ethnic backgrounds please answer not sure.  This is a perfectly acceptable answer as it is not always clear whether a particular Function meets the particular needs of people from different ethnic backgrounds.</p>"
          ],
    		2 => [
    		  "<p>The performance assessment in question 1 may have been confirmed or validated by either an internal or external inspection process.  Please answer the question to indicate whether this is the case and, if applicable, write the name of the relevant process in the text box.  Examples of the sort of thing you might include are a CPA finding or an OFSTED report.</p>"
    		  ],
    		4 => [
    		  "<p>The performance assessment in question 1 will provide the background to answering this question.  Please answer whether there are any performance issues which affect people from different ethnic groups because of their ethnic background.  Please record any such issues in the text box.  Any issues recorded should arise because of the user’s ethnicity, not just a general failing of the Function to meet user needs.</p>"
    		  ],
    },
    :disability => {
      	1 => [
        	"<p>This question asks you to assess how well the Function is performing in meeting the needs of the different groups within an Equality Strand.  The available answers are on a five point scale from 5 excellent to 1 poor.  As before Not sure if also an acceptable answer.</p>
          <p>Please answer the question, identifying how well the Function is meeting the particular needs of people with different kinds of disability.  It may be that the Function is meeting the needs of people with one type of disability very effectively but is not meeting the needs of another.</p>
          <p>If the Function is not meeting the needs of either men or women because of their disability then the Function is not performing well for the Disability Equality Strand.</p>
          <p>If you are not sure whether the Function meets the particular needs of people with different kinds of disability please answer not sure.  This is a perfectly acceptable answer as it is not always clear whether a particular Function meets the particular needs of people with different kinds of disability.</p>"
          ],
    		2 => [
    		  "<p>The performance assessment in question 1 may have been confirmed or validated by either an internal or external inspection process.  Please answer the question to indicate whether this is the case and, if applicable, write the name of the relevant process in the text box.  Examples of the sort of thing you might include are a CPA finding or an OFSTED report.</p>"
    		  ],
    		4 => [
    		  "<p>The performance assessment in question 1 will provide the background to answering this question.  Please answer whether there are any performance issues which affect people with different kinds of disability because of their disability.  Please record any such issues in the text box.  Any issues recorded should arise because of the user’s disability, not just a general failing of the Function to meet user needs.</p>"
    		  ],
    },
    :faith => {
      	1 => [
        	"<p>This question asks you to assess how well the Function is performing in meeting the needs of the different groups within an Equality Strand.  The available answers are on a five point scale from 5 excellent to 1 poor.  As before Not sure if also an acceptable answer.</p>
        	<p>Please answer the question, identifying how well the Function is meeting the particular needs of people of different faiths.  It may be that the Function is meeting the needs of people of one faith very effectively but is not meeting the needs of another.</p>
          <p>If the Function is not meeting the needs of people of different faiths because of their faith then the Function is not performing well for the Faith Equality Strand.</p>
          <p>If you are not sure whether the Function meets the particular needs of people of different faiths please answer not sure.  This is a perfectly acceptable answer as it is not always clear whether a particular Function meets the particular needs of people of different faiths.</p>"
          ],
    		2 => [
    		  "<p>The performance assessment in question 1 may have been confirmed or validated by either an internal or external inspection process.  Please answer the question to indicate whether this is the case and, if applicable, write the name of the relevant process in the text box.  Examples of the sort of thing you might include are a CPA finding or an OFSTED report.</p>"
    		  ],
    		4 => [
    		  "<p>The performance assessment in question 1 will provide the background to answering this question.  Please answer whether there are any performance issues which affect people of different faiths because of their faith.  Please record any such issues in the text box.  Any issues recorded should arise because of the user’s faith, not just a general failing of the Function to meet user needs.</p>"
    		  ],
    },
    :sexual_orientation => {
      	1 => [
        	"<p>This question asks you to assess how well the Function is performing in meeting the needs of the different groups within an Equality Strand.  The available answers are on a five point scale from 5 excellent to 1 poor.  As before Not sure if also an acceptable answer.</p>
        	<p>Please answer the question, identifying how well the Function is meeting the particular needs of people of different sexual orientations.  It may be that the Function is meeting the needs of people of one sexual orientation very effectively but is not meeting the needs of another.</p>
          <p>If the Function is not meeting the needs of people of different sexual orientations because of their sexual orientation then the Function is not performing well for the Sexual Oreientation Equality Strand.</p>
          <p>If you are not sure whether the Function meets the particular needs of people of different sexual orientations please answer not sure.  This is a perfectly acceptable answer as it is not always clear whether a particular Function meets the particular needs of people of different sexual orientations.</p>"
          ],
    		2 => [
    		  "<p>The performance assessment in question 1 may have been confirmed or validated by either an internal or external inspection process.  Please answer the question to indicate whether this is the case and, if applicable, write the name of the relevant process in the text box.  Examples of the sort of thing you might include are a CPA finding or an OFSTED report.</p>"
    		  ],
    		4 => [
    		  "<p>The performance assessment in question 1 will provide the background to answering this question.  Please answer whether there are any performance issues which affect people of different sexual orientations because of their sexual orientation.  Please record any such issues in the text box.  Any issues recorded should arise because of the user’s sexual orientation, not just a general failing of the Function to meet user needs.</p>"
    		  ],
    },
    :age => {
      	1 => [
        	"<p>This question asks you to assess how well the Function is performing in meeting the needs of the different groups within an Equality Strand.  The available answers are on a five point scale from 5 excellent to 1 poor.  As before Not sure if also an acceptable answer.</p>
        	<p>Please answer the question, identifying how well the Function is meeting the particular needs of people of different ages.  It may be that the Function is meeting the needs of people of one faith very effectively but is not meeting the needs of another.</p>
          <p>If the Function is not meeting the needs of people of different ages women because of their age then the Function is not performing well for the Age Equality Strand.</p>
          <p>If you are not sure whether the Function meets the particular needs of people of different ages please answer not sure.  This is a perfectly acceptable answer as it is not always clear whether a particular Function meets the particular needs of people of different ages.</p>"
          ],
    		2 => [
    		  "<p>The performance assessment in question 1 may have been confirmed or validated by either an internal or external inspection process.  Please answer the question to indicate whether this is the case and, if applicable, write the name of the relevant process in the text box.  Examples of the sort of thing you might include are a CPA finding or an OFSTED report.</p>"
    		  ],
    		4 => [
    		  "<p>The performance assessment in question 1 will provide the background to answering this question.  Please answer whether there are any performance issues which affect people of different ages because of their age.  Please record any such issues in the text box.  Any issues recorded should arise because of the user’s age, not just a general failing of the Function to meet user needs.</p>"
    		  ],
    }
  },
  :confidence_information => { 
	  :gender => {
      	1 => ["<p>Ideally the assessment of the performance will be based upon sound quantitative information; however, there may be gaps in the information about how the Function meets the particular needs of men and women. These gaps may be that relevant data is not collected, that the information is out of date or does not distinguish the performance of the function between men and women.</p>"],
    		2 => ["<p>There may be plans to close any gaps in information by collecting more information.</p>"],
    		3 => ["<p>If there are plans to collect further information about how the Function meets the particular needs of men and women what is the timescale for the information being ready to use.</p>"],
    		4 => ["<p>There may be other ways to assess the performance of the Function in meeting the needs of men and women. These might be customer surveys, consultation or an analysis of complaints received.</p>"]
    },
    :race => {
      	1 => ["<p>Ideally the assessment of the performance will be based upon sound quantitative information; however, there may be gaps in the information about how the Function meets the particular needs of people from different ethnic backgrounds.  These gaps may be that relevant data is not collected, that the information is out of date or does not distinguish the performance of the function between people from different ethnic backgrounds.</p>"],
    		2 => ["<p>There may be plans to close any gaps in information by collecting more information.</p>"],
    		3 => ["<p>If there are plans to collect further information about how the Function meets the particular needs of people from different ethnic backgrounds what is the timescale for the information being ready to use</p>"],
    		4 => ["<p>There may be other ways to assess the performance of the Function in meeting the needs of people from different ethnic backgrounds.   These might be customer surveys, consultation or an analysis of complaints received.</p>"]
    },
    :disability => {
      	1 => ["<p>Ideally the assessment of the performance will be based upon sound quantitative information; however, there may be gaps in the information about how the Function meets the particular needs of people with different kinds of disability.  These gaps may be that relevant data is not collected, that the information is out of date or does not distinguish the performance of the function between people with different kinds of disability.</p>"],
    		2 => ["<p>There may be plans to close any gaps in information by collecting more information.</p>"],
    		3 => ["<p>If there are plans to collect further information about how the Function meets the particular needs of people with different kinds of disability what is the timescale for the information being ready to use</p>"],
    		4 => ["<p>There may be other ways to assess the performance of the Function in meeting the needs of people with different kinds of disability.   These might be customer surveys, consultation or an analysis of complaints received.</p>"]
    },
    :faith => {
      	1 => ["<p>Ideally the assessment of the performance will be based upon sound quantitative information; however, there may be gaps in the information about how the Function meets the particular needs of people of different faiths.  These gaps may be that relevant data is not collected, that the information is out of date or does not distinguish the performance of the function between people of different faiths.</p>"],
    		2 => ["<p>There may be plans to close any gaps in information by collecting more information.</p>"],
    		3 => ["<p>If there are plans to collect further information about how the Function meets the particular needs of people of different faiths what is the timescale for the information being ready to use</p>"],
    		4 => ["<p>There may be other ways to assess the performance of the Function in meeting the needs of people of different faiths.   These might be customer surveys, consultation or an analysis of complaints received.</p>"]
    },
    :sexual_orientation => {
      	1 => ["<p>Ideally the assessment of the performance will be based upon sound quantitative information; however, there may be gaps in the information about how the Function meets the particular needs of people of different sexual orientations.  These gaps may be that relevant data is not collected, that the information is out of date or does not distinguish the performance of the function between people of different sexual orientations.</p>"],
    		2 => ["<p>There may be plans to close any gaps in information by collecting more information.</p>"],
    		3 => ["<p>If there are plans to collect further information about how the Function meets the particular needs of people of different sexual orientations what is the timescale for the information being ready to use</p>"],
    		4 => ["<p>There may be other ways to assess the performance of the Function in meeting the needs of people of different sexual orientations.   These might be customer surveys, consultation or an analysis of complaints received.</p>"]
    },
    :age => {
      	1 => ["<p>Ideally the assessment of the performance will be based upon sound quantitative information; however, there may be gaps in the information about how the Function meets the particular needs of people of different ages.  These gaps may be that relevant data is not collected, that the information is out of date or does not distinguish the performance of the function between people of different ages.</p>"],
    		2 => ["<p>There may be plans to close any gaps in information by collecting more information.</p>"],
    		3 => ["<p>If there are plans to collect further information about how the Function meets the particular needs of people of different ages what is the timescale for the information being ready to use</p>"],
    		4 => ["<p>There may be other ways to assess the performance of the Function in meeting the needs of people of different ages.   These might be customer surveys, consultation or an analysis of complaints received.</p>"]
    }
  },
  :confidence_consultation => {
	  :gender => {
        1 => ["<p>Groups representing the interests of men or women may have consulted about the potential differential impact of Function on the either men or women.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
        2 => ["<p>If no such groups have been consulted there are a number of reasons why this may be so.  There may be no appropriate groups to consult, there may be plans to consult groups but they have not taken place or they may be no plans to consult the groups.  You might not be sure why no consultation has taken place.</p>"],
        3 => ["<p>If appropriate groups representing the interests of men and women have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
        4 => ["<p>Experts in the field of gender equality may have consulted about the potential differential impact of Function on the either men or women.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
        5 => ["<p>If no such experts have been consulted there are a number of reasons why this may be so.  There may be no appropriate experts to consult, there may be plans to consult experts but they have not taken place or they may be no plans to consult expert.  You might not be sure why no consultation has taken place.</p>"],
        6 => ["<p>If appropriate gender equality experts have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
        7 => ["<p>The consultations may have identified issues with the performance of the Function in meeting the particular needs of men and women.</p>"]
    },
    :race => {
      1 => ["<p>Groups representing the interests of people from different ethnic backgrounds may have consulted about the potential differential impact of Function on individuals from different ethnic groups.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      2 => ["<p>If no such groups have been consulted there are a number of reasons why this may be so.  There may be no appropriate groups to consult, there may be plans to consult groups but they have not taken place or they may be no plans to consult the groups.  You might not be sure why no consultation has taken place.</p>"],
      3 => ["<p>If appropriate groups representing the interests of people from different ethnic backgrounds have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      4 => ["<p>Experts in the field of race equality may have consulted about the potential differential impact of Function on people from different ethnic backgrounds. Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      5 => ["<p>If no such experts have been consulted there are a number of reasons why this may be so.  There may be no appropriate experts to consult, there may be plans to consult experts but they have not taken place or they may be no plans to consult expert.  You might not be sure why no consultation has taken place.</p>"],
      6 => ["<p>If appropriate gender equality experts have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      7 => ["<p>The consultations may have identified issues with the performance of the Function in meeting the particular needs of people from different ethnic backgrounds.</p>"]
    },
    :disability => {
      1 => ["<p>Groups representing the interests of people with different kinds of disability may have consulted about the potential differential impact of Function on individuals from different ethnic groups.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      2 => ["<p>If no such groups have been consulted there are a number of reasons why this may be so.  There may be no appropriate groups to consult, there may be plans to consult groups but they have not taken place or they may be no plans to consult the groups.  You might not be sure why no consultation has taken place.</p>"],
      3 => ["<p>If appropriate groups representing the interests of people with different kinds of disability have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      4 => ["<p>Experts in the field of disability equality may have consulted about the potential differential impact of Function on people with different kinds of disability.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      5 => ["<p>If no such experts have been consulted there are a number of reasons why this may be so.  There may be no appropriate experts to consult, there may be plans to consult experts but they have not taken place or they may be no plans to consult expert.  You might not be sure why no consultation has taken place.</p>"],
      6 => ["<p>If appropriate gender equality experts have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      7 => ["<p>The consultations may have identified issues with the performance of the Function in meeting the particular needs of people with different kinds of disability.</p>"]
    },
    :faith => {
      1 => ["<p>Groups representing the interests of people of different faiths may have consulted about the potential differential impact of Function on individuals from different ethnic groups.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      2 => ["<p>If no such groups have been consulted there are a number of reasons why this may be so.  There may be no appropriate groups to consult, there may be plans to consult groups but they have not taken place or they may be no plans to consult the groups.  You might not be sure why no consultation has taken place.</p>"],
      3 => ["<p>If appropriate groups representing the interests of people of different faiths have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      4 => ["<p>Experts in the field of faith equality may have consulted about the potential differential impact of Function on people of different faiths.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      5 => ["<p>If no such experts have been consulted there are a number of reasons why this may be so.  There may be no appropriate experts to consult, there may be plans to consult experts but they have not taken place or they may be no plans to consult expert.  You might not be sure why no consultation has taken place.</p>"],
      6 => ["<p>If appropriate gender equality experts have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      7 => ["<p>The consultations may have identified issues with the performance of the Function in meeting the particular needs of people of different faiths.</p>"]
    },
    :sexual_orientation => {
      1 => ["<p>Groups representing the interests of people of different sexual orientations may have consulted about the potential differential impact of Function on individuals from different ethnic groups.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      2 => ["<p>If no such groups have been consulted there are a number of reasons why this may be so.  There may be no appropriate groups to consult, there may be plans to consult groups but they have not taken place or they may be no plans to consult the groups.  You might not be sure why no consultation has taken place.</p>"],
      3 => ["<p>If appropriate groups representing the interests of people of different sexual orientations have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      4 => ["<p>Experts in the field of Lesbian, Gay, Bi-sexual and Transgender equality may have consulted about the potential differential impact of Function on people of different sexual orientations.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      5 => ["<p>If no such experts have been consulted there are a number of reasons why this may be so.  There may be no appropriate experts to consult, there may be plans to consult experts but they have not taken place or they may be no plans to consult expert.  You might not be sure why no consultation has taken place.</p>"],
      6 => ["<p>If appropriate gender equality experts have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      7 => ["<p>The consultations may have identified issues with the performance of the Function in meeting the particular needs of people of different sexual orientations.</p>"]
    },
    :age => {
      1 => ["<p>Groups representing the interests of people of different ages may have consulted about the potential differential impact of Function on individuals from different ethnic groups.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      2 => ["<p>If no such groups have been consulted there are a number of reasons why this may be so.  There may be no appropriate groups to consult, there may be plans to consult groups but they have not taken place or they may be no plans to consult the groups.  You might not be sure why no consultation has taken place.</p>"],
      3 => ["<p>If appropriate groups representing the interests of people of different ages have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      4 => ["<p>Experts in the field of age equality may have consulted about the potential differential impact of Function on people of different ages.  Such consultation may have been conducted specifically as part of the assessment process or may have had another purpose but supplied information to the assessment process.</p>"],
      5 => ["<p>If no such experts have been consulted there are a number of reasons why this may be so.  There may be no appropriate experts to consult, there may be plans to consult experts but they have not taken place or they may be no plans to consult expert.  You might not be sure why no consultation has taken place.</p>"],
      6 => ["<p>If appropriate gender equality experts have been consulted it will be useful to record the details of the consultation.  The details do not need to be completely comprehensive but enough to provide evidence of the activity undertaken.</p>"],
      7 => ["<p>The consultations may have identified issues with the performance of the Function in meeting the particular needs of people of different ages.</p>"]
    }
  }
}

