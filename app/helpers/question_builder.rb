#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class QuestionBuilder < ActionView::Helpers::FormBuilder

  # Generates all the HTML needed for a form question
  def question(section, options={})
    f_id = options[:f_id]
    activity = Activity.find(f_id)
    strand=options[:equality_strand].to_sym
    number=options[:number].to_i
    question="#{section}_#{strand}_#{number}"
    # Get the label text for this question
    query = activity.question_wording_lookup(section.to_sym, strand.to_sym, number)
    label = query[0]
    type = query[1].to_sym
    choices = query[2]
    help = query[3]
    look_up_choices = activity.hashes['choices']
    # Get the answer options for this question and make an appropriate input field
    input_field = case type
    when :text
      text_area question
    when :string
      text_field question
    when :select
      select question, look_up_choices[choices].collect{|l| [l, look_up_choices[choices].index(l)]}
    end

    # Show our formatted question!
	  unless help == ""
      %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}<img src="/assets/icons/help.gif" onclick="Element.toggle('help_#{section}_#{strand}_#{number}')"></p><span id="help_#{section}_#{strand}_#{number}" class="toggleHelp" style="display:none;">#{help}</span><div class="clear"></div>]
    else
       %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
    end
  end
end
