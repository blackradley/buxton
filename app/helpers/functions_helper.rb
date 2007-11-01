# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
module FunctionsHelper
  #
  # Show a tick or cross, if all the questions in the section of this function have been answered
  # TODO: Not DRY enough
  #
    def completed_tag(function, section=nil, strand=nil)
      complete_icon = image_tag('icons/tick.gif', :alt => "Complete", :title => "Complete")
      incomplete_icon = image_tag('icons/cross.gif', :alt => "Incomplete", :title => "Incomplete")
     (function.completed(section, strand)) ? complete_icon : incomplete_icon
    end
#
# Show a tick or cross, if the function is approved or not.
#
  def approved_tag(is_ticked)
    if is_ticked
      return image_tag('icons/tick.gif', :alt => "Approved", :title => "Approved")
    else
      return image_tag('icons/cross.gif', :alt => "Not approved yet", :title => "Not approved yet")
    end
  end
#
# If the approver field is blank, return some other string, otherwise the 
# table of functions looks a bit odd with blanks in it.  Then again this might
# be what you want.  On the whole I think having some kind of 'null' entry 
# makes sense.
#
  def approver_or_blank(approver)
    if approver.nil? or approver.blank?
      return 'Not answered'
    else
      approver
    end
  end
  
  def impact_tag(function)
    if function.completed then
      function.statistics.impact.to_s.capitalize
    else
      '-'
    end
  end

  def priority_tag(function)
    if function.completed then
      function.statistics.fun_priority_ranking
    else
      '-'
    end
  end
  
  def relevance_tag(function)
    if function.completed then
      (function.statistics.fun_relevance) ? 'Yes' : 'No'
    else
      '-'
    end    
  end
  
end
