# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
module ActivitiesHelper
  #
  # Show a tick or cross, if all the questions in the section of this activity have been answered
  #
    def completed_tag(activity, section=nil, strand=nil)
      if activity.completed(section, strand) then
        image_tag('icons/tick.gif', :alt => "Complete", :title => "Complete")
      else
        image_tag('icons/cross.gif', :alt => "Incomplete", :title => "Incomplete")
      end
    end
#
# Show a tick or cross, if the activity is approved or not.
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
# table of activities looks a bit odd with blanks in it.  Then again this might
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
  
  def impact_tag(activity)
    if activity.completed then
      activity.statistics.impact.to_s.capitalize
    else
      '-'
    end
  end

  def priority_tag(activity)
    if activity.completed then
      activity.statistics.priority_ranking
    else
      '-'
    end
  end
  
  def relevance_tag(activity)
    if activity.completed then
      (activity.statistics.relevance) ? 'Yes' : 'No'
    else
      '-'
    end    
  end
  
end
