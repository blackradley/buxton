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
  # Display the users progress through the questions, this is used both in the
  # Function and on the Organisation, hence it is here in the ApplicationHelper.
  def progress_bar(percentage, width=100)
    if percentage > 100 then percentage = 100 end
    case width
    when 100
      image_tag("bars/small/#{percentage}.png")
    when 200
      image_tag("bars/large/#{percentage}.png")
    else
      "A progress bar of this size doesn't exist. Please contact an administrator"
    end
    # options = {:controller => 'generate', :action => 'bar', :id => percentage}
    # if width then options.store(:width, width) end
    # image_tag(url_for(options))
  end
  
  # Extend the date formats to include some British styley ones
  ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
    :default => "%m/%d/%Y %H:%M",
    :date_time12 => "%d %b %Y %I:%M%p",
    :date_time24 => "%d %b %Y %H:%M"
  )

  # Format the date or say there is nothing, rather than just outputting
  # a blank or the date from the begining of the epoch.
  def date_or_blank(date)
    if date.nil?
      return 'no date'
    else
      return date.to_formatted_s(:date_time12)
    end
  end

  # Show the logged in user type.
  def login_status()
    if @current_user.nil?
      ''
    else
      case @current_user.class.name
        when 'FunctionManager'
          'Logged in as a Function Manager'
        when 'OrganisationManager'
          'Logged in as an Organisation Manager'
        when 'Administrator'
          'Logged in as an Administration Manager'
        else
          'Login status unknown'
      end
    end
  end
  
  # Takes a list of links and generates a menu accordingly.
  # On state provided by introduction of class="selected"
  def generate_menu(links)
    link_html = ''
    links.each do |link|
      class_name = (current_page?(link[:url])) ? 'selected' : ''
      if link[:status] == 'disabled'
        link_html << content_tag('li', link_to(link[:text], link['#'], :title => link[:title]),
          { :class => class_name + ' disabled' })
      else
        link_html << content_tag('li', link_to(link[:text], link[:url], :title => link[:title]),
          { :class => class_name })
      end
    end
    content_tag('ul', link_html, :id => 'menuBar')
  end

  # Display a coloured bar showing the level selected, produced 
  # entirely via div's courtessy of Sam.
  def level_bar(value, out_of, css_class)
    html = 'Not answered yet'
    if value != 0
      percentage = (value.to_f / (out_of.length - 1)) * 100.0
      percentage = percentage.round
      html = progress_bar(percentage)
    end
    return html
  end

  # Shows a menu bar. Different for different user types. 
  def menu()
    if @current_user.nil?
      ' '
    else
      case @current_user.class.name
      when 'OrganisationManager'
        generate_menu( [
                        { :text => 'Summary',
                          :url => { :controller => 'functions', :action => 'summary' },
                          :title => 'Organisation Control Page - Summary',
                          :status => '' },
                        { :text => 'Functions',
                          :url => { :controller => 'functions', :action => 'list' },
                          :title => 'Organisation Control Page - Functions' ,
                          :status => '' },
                        { :text => 'Sections',
                          :url => { :controller => 'sections', :action => 'list', :id => 'purpose' },
                          :title => 'Organisation Control Page - Sections',
                          :status => '' }
                        ])
      when 'FunctionManager'
          puts @current_user.function.function_policy
         links = [
                    { :text => 'Home',
                      :url => { :controller => 'functions', :action => 'index'},
                      :title => 'Function Control Page - Home' ,
                      :status => '' },
                    { :text => 'Activity Type',
                      :url => { :controller => 'functions', :action => 'activity_type'},
                      :title => 'Function Control Page - Activity Type' ,
                      :status => '' }
                  ]
        if @current_user.function.started
          links2 = [    
                      { :text => 'Overview',
                        :url => { :controller => 'functions', :action => 'overview'},
                        :title => 'Function Control Page - Overview',
                        :status => '' },
                      { :text => 'Summary',
                        :url => { :controller => 'functions', :action => 'show' },
                        :title => 'Function Control Page - Summary' ,
                        :status => '' }
                    ]
        else
          puts "hellllllllllllo!"
          links2 = [    
                      { :text => 'Overview',
                        :url => { :controller => 'functions', :action => 'overview'},
                        :title => 'Function Control Page - Overview',
                        :status => 'disabled' },
                      { :text => 'Summary',
                        :url => { :controller => 'functions', :action => 'show' },
                        :title => 'Function Control Page - Summary' ,
                        :status => 'disabled' }
                    ]
        end
        
        generate_menu(links + links2)  
                    
      when 'Administrator'
        generate_menu( [
                        { :text => 'Organisations',
                          :url => { :controller => 'organisations', :action => 'list'},
                          :title => 'Organisations - Overview' },
                        { :text => 'New Demo',
                          :url => { :controller => 'demos', :action => 'new' },
                          :title => 'New Demo' }
                        ])
      else
        'Menu Fail (admin test)'
      end
    end
  end
  
#generates strand nav bar
def strand_menu()
  id = params[:id] 
  if params[:equality_strand]
    purpose_sel = "#{'selected' if (id == 'purpose')}"
    perf_sel = "#{'selected' if (id == 'performance')}"
    ci_sel = "#{'selected' if (id == 'confidence_information')}"
    cc_sel = "#{'selected' if (id == 'confidence_consultation')}"
    aw_sel = "#{'selected' if (id == 'additional_work')}"
    ap_sel = "#{'selected' if (id == 'action_planning')}"
    
    html = '<div id="strand">'
      html << params[:equality_strand].titleize 
      html << " : "
      if params[:equality_strand] == 'overall' then
        html << link_to('Purpose', { :controller => 'sections', :action => 'edit', :id => 'purpose', :equality_strand => params[:equality_strand] }, :title => 'Edit Purpose', :class => purpose_sel)      
        html << ' >> '
      end
      html << link_to('Performance', { :controller => 'sections', :action => 'edit', :id => 'performance', :equality_strand => params[:equality_strand] }, :title => 'Edit Performance', :class => perf_sel)   
      html << ' >> '
      html << link_to('Confidence Information', { :controller => 'sections', :action => 'edit', :id => 'confidence_information', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Information', :class => ci_sel)    
      unless params[:equality_strand] == 'overall'
        html << ' >> '
        html << link_to('Confidence Consultation', { :controller => 'sections', :action => 'edit', :id => 'confidence_consultation', :equality_strand => params[:equality_strand] }, :title => 'Edit Confidence Consultation', :class => cc_sel)
        html << ' >> '
        html << link_to('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equality_strand => params[:equality_strand] }, :title => 'Additional Work', :class => aw_sel)
        html << ' >> '
        html << link_to('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equality_strand => params[:equality_strand] }, :title => 'Action Planning', :class => ap_sel) 
      end
    html << "</div>"		
    return html
  else
    return ''
  end
end
#This generates the menu bar at the top in the list sections pages.
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

  # Get the label text and details for this question
  query = function.question_wording_lookup(section, strand,number)
  question="#{section}_#{strand}_#{number}"
  label = query[0]
  choices = function.hashes['choices'][query[2]]
  # Get the answer options for this question and make an appropriate input field
  question_answer = function.send(question)
  unless question_answer.nil?
    answer = case query[1].to_sym
    when :select
      choices[question_answer]
    when :text
      function.send(question)
    when :string
      function.send(question)
    end
  else
    answer = 'Not answered yet'
  end

  %Q[<p><label title="#{label}">#{label}</label><div class="labelled">#{h answer}</div></p>]
end
  #This method produces an answer bar for the summary sections
  def summary_answer(function, section, strand, number)
     label = function.question_wording_lookup(section, strand,number)[0]
     question="#{section}_#{strand}_#{number}"

     barImage = level_bar(function.send(question), function.hashes['choices'][7], 'bar-impact-groups')

         # Show our formatted question!
         %Q[<p>
         <label title="#{label}">#{label}</label>
         <div class="labelled">#{barImage}</div>
         </p>]
         #%Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
   end
end