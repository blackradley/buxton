module SectionsHelper
  #
  # If the strategy response is not set for a function, return 0 instead.
  # 
  def strategy_response_or_zero(function_responses, id)
    function_response = function_responses.find_by_strategy_id(id)
    if function_response.nil?
      return 0
    else
      return function_response.strategy_response
    end
  end
  
  def header_with_help(id, text_title, text_help)
    %Q[<h4>#{text_title} #{link_to_function image_tag("icons/help.gif"), "Element.toggle('#{id}')"}</h4>
    <span id="#{id}" class="toggleHelp" style="display:none;">#{text_help}</span>]
  end
  
  # Generates all the HTML needed to display the answer to a question
  def answer(function, question)

    # Get the label text for this question
    label = $questions[question][0]

    # Get the answer options for this question and make an appropriate input field
    answer = case $questions[question][1]
    when :existing_proposed
      LookUp.existing_proposed.find{|lookUp| function.send(question) == lookUp.value}.name
    when :impact_amount
      LookUp.impact_amount.find{|lookUp| function.send(question) == lookUp.value}.name
    when :impact_level
      LookUp.impact_level.find{|lookUp| function.send(question) == lookUp.value}.name
    when :rating
      LookUp.rating.find{|lookUp| function.send(question) == lookUp.value}.name
    when :yes_no_notsure
      LookUp.yes_no_notsure.find{|lookUp| function.send(question) == lookUp.value}.name
    when :text
      function.send(question)
    when :string
      function.send(question)
    end
  
    %Q[<p><label title="#{label}">#{label}</label><div class="labelled">#{answer}</div></p>]
  end
  
end
