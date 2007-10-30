#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
class QuestionBuilder < ActionView::Helpers::FormBuilder    

  # Generates all the HTML needed for a form question
  def question(section, options={})
    f_id = options[:f_id]
    function = Function.find(f_id)
    strand=options[:equality_strand].to_sym
    number=options[:number]
    question="#{section}_#{strand}_#{number}"
    # Get the label text for this question
    label = function.question_wording_lookup(section.to_sym, strand.to_sym, number)[0]
    type = function.question_wording_lookup(section.to_sym, strand.to_sym,number)[1] 
    # Get the answer options for this question and make an appropriate input field
    input_field = case type     
    when :existing_proposed
      select question, LookUp.existing_proposed.collect {|l| [ l.name, l.value ] }
    when :function_policy
      select question, LookUp.function_policy.collect {|l| [ l.name, l.value ] }
    when :impact_amount
      select question, LookUp.impact_amount.collect {|l| [ l.name, l.value ] }
    when :impact_level
      select question, LookUp.impact_level.collect {|l| [ l.name, l.value ] }
    when :rating
      select question, LookUp.rating.collect {|l| [ l.name, l.value ] }
    when :yes_no_notsure
      select question, LookUp.yes_no_notsure.collect {|l| [ l.name, l.value ] }
    when :timescales
      select question, LookUp.timescales.collect {|l| [ l.name, l.value ] }
    when :consult_groups
      select question, LookUp.consult_groups.collect {|l| [ l.name, l.value ] }
    when :consult_experts
      select question, LookUp.consult_experts.collect {|l| [ l.name, l.value ] }
    when :yes_no
      select question, LookUp.yes_no.collect{|l| [l.name, l.value]}
    when :text
      text_area question 
    when :string
      text_field question
    end
	    
    # Show our formatted question!
	  begin
      %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}<img src="/images/icons/help.gif" onclick="Element.toggle('help_#{section}_#{strand}_#{number}')"></p><span id="help_#{section}_#{strand}_#{number}" class="toggleHelp" style="display:none;">#{$help[section][strand][number]}</span><div class="clear"></div>]
    rescue NoMethodError
       %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]   
    end
  end
end