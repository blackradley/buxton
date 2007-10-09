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
  
  
end
