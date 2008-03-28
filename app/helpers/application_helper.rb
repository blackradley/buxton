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
  # Activity and on the Organisation, hence it is here in the ApplicationHelper.
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
        when 'ActivityManager'
          'Logged in as a Activity Manager.'
        when 'OrganisationManager'
          'Logged in as an Organisation Manager.'
        when 'Administrator'
          'Logged in as an Administration Manager.'
        else
          'Login status unknown.'
      end
    end
  end
  
  
  def question_details(section, strand, questions)
    info_array = []   
    questions.each do |question|
      info = @activity.question_wording_lookup(section, strand, question)  
      look_up_choices = @activity.hashes['choices']
      choices = info[2].to_i
      choices_array=[]
      dependents=[]
      dependents_array=[]
      dependency = []

      if choices!=0
         look_up_choices[choices].each do |d|
           choices_array << [d, look_up_choices[choices].index(d)]
         end
       end
       
       dependents = @activity.dependencies("#{section}_#{strand}_#{question}")
       
        if dependents
            dependents.each do |da|
              dependents_array << [da[0], @activity.hashes[da[1]].to_i]
            end
          end
      dependency = @activity.dependent_questions("#{section}_#{strand}_#{question}") 
      name = "#{section}_#{strand}_#{question}"
      full_question = [*@current_user.activity.questions.find_by_name(name)][0]
      comment = full_question.comment
      note = full_question.note
      comment_contents = (comment.nil? ? '' : comment.contents)
      note_contents = (note.nil? ? '' : note.contents)
      info_array << {  :id => name,
                        :full_question => full_question,
                        :label => info[0],
                        :help => info[3],
                        :input_type => info[1].to_sym,
                        :input_choices => choices_array,
                        :dependents => dependents_array,
                        :dependency => dependency,
                        :input_choices => choices_array,
                        :comment => comment_contents,
                        :note => note_contents 
                      }     
       full_question.save      
    end 
    return info_array   
  end
  
  # Takes a list of links and generates a menu accordingly.
  # On state provided by introduction of class="selected"
  def generate_menu(links)
    link_html = ''
    links.each do |link|
      # Highlight the tab if it's selected, or something it should highlight on is selected
      highlight_on = [link[:url]]
      highlight_on += link[:highlight_on] if link[:highlight_on] 
      highlight = highlight_on.detect{|url| current_page?(url)}
      class_name = (highlight) ? 'selected' : ''
      # Disable the tab if told to do so
      if link[:status] == 'disabled' then
        link_html << content_tag('li', link_to(link[:text], '#'), { :class => ['disabled', class_name].join(' ') })
      else
        link_html << content_tag('li', link_to(link[:text], link[:url], :title => link[:title]),
          { :class => class_name })
      end
    end
    content_tag('ul', link_html)
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
                          :url => { :controller => 'activities', :action => 'summary' },
                          :title => 'Organisation Control Page - Summary',
                          :status => '' },
                        { :text => 'Activities',
                          :url => { :controller => 'activities', :action => 'list' },
                          :title => 'Organisation Control Page - Activities' ,
                          :status => '' },
                        { :text => 'Sections',
                          :url => { :controller => 'sections', :action => 'list', :id => 'purpose' },
                          :title => 'Organisation Control Page - Sections',
                          :status => '',
                          :highlight_on => [  { :controller => 'sections', :action => 'list', :id => 'impact' },
                                              { :controller => 'sections', :action => 'list', :id => 'consultation' },
                                              { :controller => 'sections', :action => 'list', :id => 'additional_work' },
                                              { :controller => 'sections', :action => 'list', :id => 'action_planning' } ]
                          }
                        ])
      when 'ActivityManager'
         home = [
                    { :text => 'Home',
                      :url => { :controller => 'activities', :action => 'index'},
                      :title => 'Activity Control Page - Home' ,
                      :status => '' }
                 ]
#        if @current_user.activity.ces_question.to_i > 0 then 
          questions = [   { :text => 'Questions',
                        :url => { :controller => 'activities', :action => 'questions'},
                        :title => 'Activity Control Page - Questions' ,
                        :status => '' }
                    ]   
          if @current_user.activity.completed(:purpose)
            summary= [    
                        { :text => 'Summary',
                          :url => { :controller => 'activities', :action => 'show' },
                          :title => 'Activity Control Page - Summary' ,
                          :status => '' }
                      ]
          else
            summary = [    
                        { :text => 'Summary',
                          :url => { :controller => 'activities', :action => 'show' },
                          :title => 'Activity Control Page - Summary' ,
                          :status => 'disabled' }
                      ]
          end
#        else
#          questions = [   { :text => 'Questions',
#                        :url => { :controller => 'activities', :action => 'questions'},
#                        :title => 'Activity Control Page - Questions' ,
#                        :status => 'disabled' }
#                    ]
#          summary = [    
#                         { :text => 'Summary',
#                          :url => { :controller => 'activities', :action => 'show' },
#                          :title => 'Activity Control Page - Summary' ,
#                          :status => 'disabled' }
#                      ] 
#        end      
        generate_menu(home + questions + summary)
                    
      when 'Administrator'
        generate_menu( [
                        { :text => 'Manage Organisations',
                          :url => organisations_url,
                          :title => 'Organisations - Organisation Overview' },
                        { :text => 'View Log',
                          :url => { :controller => 'logs' },
                          :title => 'Organisations - View Log of Activity' },
                        { :text => 'New Demo',
                          :url => { :controller => 'demos', :action => 'new' },
                          :title => 'Create a New Demo' }
                        ])
      else
        'Menu Fail (admin test)'
      end
    end
  end
  
  #generates strand nav bar
  def strand_menu()
    id = params[:id] 
    if params[:equality_strand] && params[:equality_strand] != 'overall'
      purpose_sel = "#{'selected' if (id == 'purpose')}"
      impact_sel = "#{'selected' if (id == 'impact')}"
      cc_sel = "#{'selected' if (id == 'consultation')}"
      aw_sel = "#{'selected' if (id == 'additional_work')}"
      ap_sel = "#{'selected' if (id == 'action_planning')}"
    
      html = '<div id="strand">'
      html << params[:equality_strand].titleize 
      html << " : "
      html << link_to('Impact', { :controller => 'sections', :action => 'edit', :id => 'impact', :equality_strand => params[:equality_strand] }, :title => 'Edit Impact', :class => impact_sel) 
      html << ' >> '
      html << link_to('Consultation', { :controller => 'sections', :action => 'edit', :id => 'consultation', :equality_strand => params[:equality_strand] }, :title => 'Edit Consultation', :class => cc_sel)
      html << ' >> '
      html << link_to('Additional Work', { :controller => 'sections', :action => 'edit', :id => 'additional_work', :equality_strand => params[:equality_strand] }, :title => 'Additional Work', :class => aw_sel)
      html << ' >> '
      html << link_to('Action Planning', { :controller => 'sections', :action => 'edit', :id => 'action_planning', :equality_strand => params[:equality_strand] }, :title => 'Action Planning', :class => ap_sel) 
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
    { :text => 'Impact',
      :url => { :controller => 'sections', :action => 'list', :id => 'impact' },
      :title => 'Organisation Control Page - Section - Impact' },
    { :text => 'Consultation',
      :url => { :controller => 'sections', :action => 'list', :id => 'consultation' },
      :title => 'Organisation Control Page - Section - Consultation' },
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
  def answer(activity, section, strand, number)
    question_name="#{section}_#{strand}_#{number}"
    question = activity.questions.find_by_name(question_name)
    return "" unless question.needed

    # Get the label text and details for this question
    query = activity.question_wording_lookup(section, strand, number)
    label = query[0]
    choices = activity.hashes['choices'][query[2]]
    # Get the answer options for this question and make an appropriate input field
    question_answer = activity.send(question_name)
    unless question_answer.nil?
      answer = case query[1].to_sym
      when :select
        choices[question_answer]
      when :text
        activity.send(question_name)
      when :string
        activity.send(question_name)
      end
    else
      answer = 'Not Answered Yet'
    end

    if comment = question.comment then
      tooltip_id = "comment_tooltip_#{comment.id}"
      image_id = "comment_#{comment.id}"
      comment_string = %Q[<div id='#{tooltip_id}' class="comment_tooltip">#{comment.contents}</div>
      #{image_tag('icons/comment.gif', :id => image_id)}
      <script type="text/javascript">var my_tooltip = new Tooltip('#{image_id}', '#{tooltip_id}');</script>]
    else
      comment_string = ""
    end
    %Q[<tr><td class="label">#{label}</td><td class="labelled">#{h answer}#{comment_string}</td></tr>]
  end

  #This method produces an answer bar for the summary sections
  def summary_answer(activity, section, strand, number)
     label = activity.question_wording_lookup(section, strand,number)[0]
     question="#{section}_#{strand}_#{number}"

     barImage = level_bar(activity.send(question), activity.hashes['choices'][7], 'bar-impact-groups')

     # Show our formatted question!
     %Q[<p>
     <label title="#{label}">#{label}</label>
     <div class="labelled">#{barImage}</div>
     </p>]
     #%Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
   end
   
end
