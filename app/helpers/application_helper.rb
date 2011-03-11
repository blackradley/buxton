module ApplicationHelper
  
  # Display the users progress through the questions, this is used both in the
  # Activity and on the Organisation, hence it is here in the ApplicationHelper.
  def progress_bar(percentage, width=100)
    if percentage > 100 then percentage = 100 end
    label = "#{percentage}%"
    case width
    when 100
      image_tag("bars/small/#{percentage}.png", :alt => label, :title => label)
    when 200
      image_tag("bars/large/#{percentage}.png", :alt => label, :title => label)
    else
      "A progress bar of this size doesn't exist. Please contact an administrator"
    end
    # options = {:controller => 'generate', :action => 'bar', :id => percentage}
    # if width then options.store(:width, width) end
    # image_tag(url_for(options))
  end

  # # Extend the date formats to include some British styley ones
  # ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  #   :default => "%m/%d/%Y %H:%M",
  #   :date_time12 => "%d %b %Y %I:%M%p",
  #   :date_time24 => "%d %b %Y %H:%M"
  # )

  # Format the date or say there is nothing, rather than just outputting
  # a blank or the date from the begining of the epoch.
  def date_or_blank(date)
    if date.nil?
      return 'unsent'
    else
      return date.to_formatted_s(:date_time12)
    end
  end
  

  # Show the logged in user type.
  def login_status
    "Logged in as #{current_user.email}"
  end

  def ot(term)
    if @current_user.nil?
      ''
    else
      @current_user.term(term)
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
      full_question = [*@activity.questions.find_by_name(name)][0]
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

  def activities_menu
    current_user.roles.map do |role| 
      case role
      when "Completer"
        ["My Eina's", my_einas_activities_path]
      when "Approver"
        ["Assisting", assisting_activities_path]
      when "Creator"
        ["Directorate Eina's", directorate_einas_activities_path]
      end
    end
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


  # Generates all the HTML needed to display the answer to a question
  def answer(activity, activity_questions, section, strand, ids)
    output = Array(ids).collect do |id|
      name = "#{section}_#{strand}_#{id}"
      #question = activity.questions.find_by_name(name)
      question = activity_questions[name][0]
      comment = activity_questions[name][1]
      next unless question.needed

      query = activity.question_wording_lookup(question.section, question.strand, question.number, true)

      label = query[0]
      choices = activity.hashes['choices'][query[2]]

      # Get the answer options for this question and make an appropriate input field
      question_answer = activity.send(question.name)

      unless question_answer.nil?
        answer = case query[1].to_sym
        when :select
          choices[question_answer]
        when :text
          question_answer
        when :string
          question_answer
        end
      else
        answer = 'Not Answered Yet'
      end

      render :partial => '/activities/answer', :locals => { :label => label, :answer => answer, :question => question, :comment => comment }
    end

    raw(output)
  end

  #This method produces an answer bar for the summary sections
  def summary_answer(activity, section, strand, number)
     label = activity.question_wording_lookup(section, strand,number)[0]
     question="#{section}_#{strand}_#{number}"

     barImage = level_bar(activity.send(question), activity.hashes['choices'][7], 'bar-impact-groups')

     # Show our formatted question!
     raw(%Q[<p>
     <label title="#{label}">#{label}</label>
     <div class="labelled">#{barImage}</div>
     </p>])
     #%Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
   end
   
  def strand_display(strand)
    strand.to_s.downcase == 'faith' ? 'religion or belief' : strand
  end
  
  def sentence_desc(strand)
    case strand.to_s
    when 'race'
      'ethnicity'
    when 'faith'
      'religion or belief'
    else
      strand.to_s.titleize.downcase
    end
  end
  
end
