# 
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
module FunctionsHelper
#
# Show a tick or cross, if the function is approved or not.
#
  def approved_tag(is_ticked)
    if is_ticked
      return image_tag('tick.gif', :alt => "Approved", :title => "Approved")
    else
      return image_tag('cross.gif', :alt => "Not approved yet", :title => "Not approved yet")
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
#
# Display a coloured bar showing the level selected, produced 
# entirely via div's courtessy of Sam.
# 
  def level_bar(value, out_of, css_class)
    html = 'Not answered yet'
    if value != 0
      percentage = (value.to_f / (out_of.length - 1)) * 100.0
      percentage = percentage.round
	html = "<div class='bar-background'>"
	html += "<div "
	html += "title='" + percentage.to_s + "%' "
	html += "class='" + css_class + "' "
	html += "style='width:" + percentage.to_s + "%'"
	html += "></div>"
	html += "</div>"
    end
    return html
  end 
#
# Return a yes or no for relevance, based on the Function.  A totally
# unpleasant way of doing it.  There must be a neater way of doing 
# this with a SQL statement but I can't be bothered to think about it.
# While this is just a demo doing it this way is more flexible.
# NOTE: Commented instead of deleted, for now. Removed in 27stars version 1.
  # def relevance_tag(function)
  #   html = 'No'
  #   threshold = 22.5
  #   existing_proposed_weight = LookUp.existing_proposed.find{|lookUp| function.existence_status == lookUp.value}.weight
  #   gender_weights = existing_proposed_weight + 
  #     LookUp.impact_level.find{|lookUp| function.good_gender == lookUp.value}.weight +
  #     LookUp.impact_level.find{|lookUp| function.bad_gender == lookUp.value}.weight
  #   if (gender_weights >= threshold)
  #     html = 'Yes'
  #   end
  #   race_weights = existing_proposed_weight + 
  #     LookUp.impact_level.find{|lookUp| function.good_race == lookUp.value}.weight +
  #     LookUp.impact_level.find{|lookUp| function.bad_race == lookUp.value}.weight
  #   if (race_weights >= threshold)
  #     html = 'Yes'
  #   end  
  #   disability_weights = existing_proposed_weight + 
  #     LookUp.impact_level.find{|lookUp| function.good_disability == lookUp.value}.weight +
  #     LookUp.impact_level.find{|lookUp| function.bad_disability == lookUp.value}.weight
  #   if (disability_weights >= threshold)
  #     html = 'Yes'
  #   end
  #   faith_weights = existing_proposed_weight + 
  #     LookUp.impact_level.find{|lookUp| function.good_faith == lookUp.value}.weight +
  #     LookUp.impact_level.find{|lookUp| function.bad_faith == lookUp.value}.weight
  #   if (faith_weights >= threshold)
  #     html = 'Yes'
  #   end
  #   sexual_orientation_weights = existing_proposed_weight + 
  #     LookUp.impact_level.find{|lookUp| function.good_sexual_orientation == lookUp.value}.weight +
  #     LookUp.impact_level.find{|lookUp| function.bad_sexual_orientation == lookUp.value}.weight
  #   if (sexual_orientation_weights >= threshold)
  #     html = 'Yes'
  #   end
  #   age_weights = existing_proposed_weight + 
  #     LookUp.impact_level.find{|lookUp| function.good_age == lookUp.value}.weight +
  #     LookUp.impact_level.find{|lookUp| function.bad_age == lookUp.value}.weight
  #   if (age_weights >= threshold)
  #     html = 'Yes'
  #   end
  #   return html
  # end
end
