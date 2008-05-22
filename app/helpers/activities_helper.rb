#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
module ActivitiesHelper
  #
  # Show a tick or cross, if all the questions in the section of this activity have been answered
  #
    def completed_tag(activity, section=nil, strand=nil)
      id = "#{strand}_#{section}_completed"
      if activity.completed(section, strand) then
        image_tag('icons/tick.gif', :alt => "Complete", :title => "Complete", :id => id)
      else
        image_tag('icons/cross.gif', :alt => "Incomplete", :title => "Incomplete", :id => id)
      end
    end
  #
  # Show a tick or a cross if the condition is true
  #
    def tick_cross_display(boolean)
      if boolean then
        image_tag('icons/tick.gif', :alt => "Complete", :title => "Complete")
      else
        image_tag('icons/cross.gif', :alt => "Incomplete", :title => "Incomplete")
      end
    end
#
# Show a tick or cross, if the activity is approved or not.
#
  def approved_tag(approval_status)
    if approval_status == 'approved'
      return image_tag('icons/tick.gif', :alt => "Approved", :title => "Approved")
    else
      return image_tag('icons/cross.gif', :alt => "Not approved yet", :title => "Not approved yet")
    end
  end

  def impact_tag(activity)
    if activity.completed then
      activity.impact_wording.to_s.capitalize
    else
      '-'
    end
  end

  def priority_tag(activity)
    if activity.completed then
      activity.priority_ranking
    else
      '-'
    end
  end

  def relevance_tag(activity)
    if activity.completed then
      (activity.relevant?) ? 'Yes' : 'No'
    else
      '-'
    end
  end

end
