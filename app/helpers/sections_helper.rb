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
  
  def question(f, name, type)
    input_field = case type
    when :rating
      '1-5'
    when :yes_no_notsure
      # f.select 'impact_service_users', LookUp.impact_amount.collect {|l| [ l.name, l.value ] }
      'yes no notsure'
    when :text
      f.text_area name 
    end
    "<p><label>#{$questions[name]}</label>#{input_field}</p>"
  end
  
end
