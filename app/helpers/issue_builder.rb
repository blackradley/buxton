class IssueBuilder < ActionView::Helpers::FormBuilder    

  # Generates all the HTML needed for a form question
  def question(name, issue, f_id=nil)
    issues = {:description  => :text,  :actions => :text,  :resources => :text,  :timescales => :timescales,  :lead_officer => :text}
    
    question="Issue"
    # Get the label text for this question
        label = name.to_s.gsub("_",  " ").capitalize
        # Get the answer options for this question and make an appropriate input field
        input_field = case issues[name] 
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
        when :text
          text_area question 
        when :string
          text_field question
  	end
	
    # Show our formatted question!
    %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
  end
end