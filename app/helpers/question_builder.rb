class QuestionBuilder < ActionView::Helpers::FormBuilder    

  # Generates all the HTML needed for a form question
  def question(method, options={})
    # Get the label text for this question
    label = $questions[method][0]

    # Get the answer options for this question and make an appropriate input field
    input_field = case $questions[method][1]
    when :existing_proposed
      select method, LookUp.existing_proposed.collect {|l| [ l.name, l.value ] }
    when :impact_amount
      select method, LookUp.impact_amount.collect {|l| [ l.name, l.value ] }
    when :impact_level
      select method, LookUp.impact_level.collect {|l| [ l.name, l.value ] }
    when :rating
      select method, LookUp.rating.collect {|l| [ l.name, l.value ] }
    when :yes_no_notsure
      select method, LookUp.yes_no_notsure.collect {|l| [ l.name, l.value ] }
    when :text
      text_area method 
    when :string
      text_field method
    end
    
    # Show our formatted question!
    %Q[<p><label for="#{object_name.to_s}_#{method.to_s}">#{label}</label>#{input_field}</p>]
  end
  
end