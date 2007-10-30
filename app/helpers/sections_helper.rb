#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
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
  
  def insert_help(section, strand, question)
    strand = strand.to_sym
    divId="help_#{section}_#{strand}_#{question}"
    %Q[<div class="helper">#{link_to_function image_tag("icons/help.gif"), "Element.toggle('#{divId}')"}</div>
      <span id="#{divId}" class="toggleHelp" style="display:none;">#{$help[section][strand][question][0]}</span>]
   end
  
  
end
