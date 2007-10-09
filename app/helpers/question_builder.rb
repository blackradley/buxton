class QuestionBuilder < ActionView::Helpers::FormBuilder    

  # Generates all the HTML needed for a form question
  def question(method, options={})

    puts options
    puts method
    #puts number
    strand=options[:equalityStrand].to_sym
    number=options[:number]
    question="#{method}_#{strand}_#{number}"
    # Get the label text for this question
        label = $questions[method][strand][number][0]
      
        # Get the answer options for this question and make an appropriate input field
        input_field = case $questions[method][strand][number][1]      
        when :existing_proposed
          select question, LookUp.existing_proposed.collect {|l| [ l.name, l.value ] }
        when :impact_amount
          select question, LookUp.impact_amount.collect {|l| [ l.name, l.value ] }
        when :impact_level
          select question, LookUp.impact_level.collect {|l| [ l.name, l.value ] }
        when :rating
          select question, LookUp.rating.collect {|l| [ l.name, l.value ] }
        when :yes_no_notsure
          select question, LookUp.yes_no_notsure.collect {|l| [ l.name, l.value ] }
        when :text
          text_area question 
        when :string
          text_field question
        end
        
        # Show our formatted question!
        %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
  end
  
end