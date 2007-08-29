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
module FunctionHelper
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
# The percentage number of questions answered for section 1 (the relevance
# test).  Originally this was part of the model but it has to make use of
# the Strategy table as well, which was inconvenient from the model.  Also
# you could argue that the number of questions answered is an external and
# arbitary value not inherent in the model.  In a way it is something that 
# is calculated based on the model, which is what happens here.
# 
# To prevent rounding occuring during the calculation (which would happen
# because all the values are integers) the number of questions is given with
# a decimal place to make it a float.  This seems a bit naff to me, I think
# there should be a neater way, but Ruby isn't my strongest skill.
#
  def section1_percentage_answered(function)     
    number_of_questions = 20.0 + function.organisation.strategies.count # decimal point prevents rounding
    questions_answered = function.existence_status > 0 ? 1 : 0
    questions_answered += function.impact_service_users > 0 ? 1 : 0
    questions_answered += function.impact_staff > 0 ? 1 : 0
    questions_answered += function.impact_supplier_staff > 0 ? 1 : 0
    questions_answered += function.impact_partner_staff > 0 ? 1 : 0
    questions_answered += function.impact_employees > 0 ? 1 : 0
    questions_answered += function.good_gender > 0 ? 1 : 0
    questions_answered += function.good_race > 0 ? 1 : 0
    questions_answered += function.good_disability > 0 ? 1 : 0
    questions_answered += function.good_faith > 0 ? 1 : 0
    questions_answered += function.good_sexual_orientation > 0 ? 1 : 0
    questions_answered += function.good_age > 0 ? 1 : 0
    questions_answered += function.bad_gender > 0 ? 1 : 0
    questions_answered += function.bad_race > 0 ? 1 : 0
    questions_answered += function.bad_disability > 0 ? 1 : 0
    questions_answered += function.bad_faith > 0 ? 1 : 0
    questions_answered += function.bad_sexual_orientation > 0 ? 1 : 0
    questions_answered += function.bad_age > 0 ? 1 : 0
    questions_answered += function.approved.to_i 
    questions_answered += function.approver.blank? ? 0 : 1
    function.function_strategies.each do |strategy|
      questions_answered += strategy.strategy_response > 0 ? 1 : 0
    end
    percentage = (questions_answered / number_of_questions) * 100 # calculate
    percentage = percentage.round # round to one decimal place
    return percentage
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
#
# Hash of equality dimensions questions, I figured that they might be used in a 
# number of different places.
#
  $equality_questions = {
    'good_age'=>'Would it affect different <strong>age groups</strong> differently?', 
    'good_race'=>'Would it affect different <strong>Ethnic groups</strong> differently?', 
    'good_gender'=>'Would it affect <strong>men and women</strong> differently?',
    'good_sexual_orientation'=>'Would it affect people of different <strong>sexual orientation</strong> differently?',
    'good_faith'=>'Would it affect different <strong>faith groups</strong> differently?',
    'good_disability'=>'Would it affect <strong>people with different kinds of disabilities</strong> differently?',
    'bad_age'=>'Would it affect different <strong>age groups</strong> differently?', 
    'bad_race'=>'Would it affect different <strong>Ethnic groups</strong> differently?', 
    'bad_gender'=>'Would it affect <strong>men and women</strong> differently?',
    'bad_sexual_orientation'=>'Would it affect people of different <strong>sexual orientation</strong> differently?',
    'bad_faith'=>'Would it affect different <strong>faith groups</strong> differently?',
    'bad_disability'=>'Would it affect <strong>people with different kinds of disabilities</strong> differently?'
    }
#
# Hash of impact groups, because they are used in a number of places. 
#    
   $impact_groups = {
    'service_users'=>'Service users', 
    'staff'=>'Staff employed by the council', 
    'supplier_staff'=>'Staff of supplier organisations', 
    'partner_staff'=>'Staff of partner organisations', 
    'employees'=>'Employees of businesses'
    }
end
