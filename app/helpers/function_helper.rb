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
# 
#
  def existence_status_tag(existence_status)
    look_up = LookUp.find_by_id(existence_status)
    if look_up.nil?
      return 'not set'
    else
      look_up.name
    end
  end
#
#
#
  def approver_or_blank(approver)
    if approver.nil? or approver.blank?
      return 'none'
    else
      approver
    end
  end
#
# Display level of the slider
#
  def level_bar(percentage, color_image)
    html = "<table border='0' cellpadding='0' cellSpacing='0'>"
    html += "<tr title='" + percentage.to_s + "%'>"
    html += "<td width='200' class='bar'>" + image_tag(color_image, :width => percentage * 2, :height => 10, :title=> percentage.to_s + '%') + "</td>"
    html += "</tr>"
    html += "</table>"
  end 
#
# Hash of equality dimensions questions
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
