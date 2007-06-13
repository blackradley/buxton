# 
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
module FunctionHelper
#
# Show a tick or cross, if the function is approved or not
#
  def approved_tag(is_ticked)
    if is_ticked
      return image_tag('tick.gif', :alt => "Approved", :title => "Approved")
    else
      return image_tag('cross.gif', :alt => "Not approved yet", :title => "Not approved yet")
    end
  end
#
# If the approver field is blank, return some other string 
#
  def approver_or_blank(approver)
    if approver.nil? or approver.blank?
      return 'not given'
    else
      approver
    end
  end
#
# Display a thermometer bar.
#
  def level_bar(value, out_of, color_image)
    html = $NO_ANSWER
    if value != 0
      percentage = (value.to_f / (out_of.length - 1)) * 100
      html = "<table border='0' cellpadding='0' cellSpacing='0'>"
      html += "<tr title='" + percentage.to_s + "%'>"
      html += "<td width='200' class='bar'>" + image_tag(color_image, :width => percentage * 2, :height => 10, :title=> percentage.to_s + '%') + "</td>"
      html += "</tr>"
      html += "</table>"
    end
    return html
  end 
#
# The percentage answered for section 1
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
    return (questions_answered / number_of_questions) * 100
  end
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
# Hash of equality dimensions questions, figured that they might be used in a 
# number of different places.
#
  $equality_questions = {
    'good_age'=>'If the function were performed well, would it affect different <strong>age groups</strong> differently?', 
    'good_race'=>'If the function were performed well, would it affect different <strong>Ethnic groups</strong> differently?', 
    'good_gender'=>'If the function were performed well, would it affect <strong>men and women</strong> differently?',
    'good_sexual_orientation'=>'If the function were performed well, would it affect people of different <strong>sexual orientation</strong> differently?',
    'good_faith'=>'If the function were performed well, would it affect different <strong>faith groups</strong> differently?',
    'good_disability'=>'If the function were performed well, would it affect <strong>people with different kinds of disabilities</strong> differently?',
    'bad_age'=>'If the function were performed badly, would it affect different <strong>age groups</strong> differently?', 
    'bad_race'=>'If the function were performed badly, would it affect different <strong>Ethnic groups</strong> differently?', 
    'bad_gender'=>'If the function were performed badly, would it affect <strong>men and women</strong> differently?',
    'bad_sexual_orientation'=>'If the function were performed badly, would it affect people of different <strong>sexual orientation</strong> differently?',
    'bad_faith'=>'If the function were performed badly, would it affect different <strong>faith groups</strong> differently?',
    'bad_disability'=>'If the function were performed badly, would it affect <strong>people with different kinds of disabilities</strong> differently?'
    }
end
