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
# Traffic light status
#
  def traffic_light_status_tag(traffic_light_status)
    case traffic_light_status
      when 0
        return image_tag('green.gif', :alt => "Green", :title => "Green", :width => 10, :height => 10)
      when 1
        return image_tag('amber.gif', :alt => "Amber", :title => "Amber", :width => 10, :height => 10)
      when 2
        return image_tag('red.gif', :alt => "Red", :title => "Red", :width => 10, :height => 10)
      else
        return image_tag('blue.gif', :alt => "Blue", :title => "Blue", :width => 10, :height => 10)
    end
  end
#
# Slider
#
  def standard_slider_tag(object, method)
    html = slider_field(object, method, {:values => "[0,1,2,3,4,5,6,7,8,9,10]", :range => 1..10})
    html += "<div style='width: 300px;'>"
    html += "<span style='float: left'>not at all</span><span style='float: right'>very different impact</span>"
    html += "</div>"
  end
#
# Hash of equality dimensions questions
#
  $equality_questions = {
    'good_age'=>'If the function were performed well, would it affect different <u>age groups</u> differently?', 
    'good_ethnic'=>'If the function were performed well, would it affect different <u>Ethnic groups</u> differently?', 
    'good_gender'=>'If the function were performed well, would it affect <u>men and women</u> differently?',
    'good_sexual_orientation'=>'If the function were performed well, would it affect people of different <u>sexual orientation</u> differently?',
    'good_faith'=>'If the function were performed well, would it affect different <u>faith groups</u> differently?',
    'good_ability'=>'If the function were performed well, would it affect <u>people with different kinds of disabilities</u> differently?',
    'bad_age'=>'If the function were performed badly, would it affect different <u>age groups</u> differently?', 
    'bad_ethnic'=>'If the function were performed badly, would it affect different <u>Ethnic groups</u> differently?', 
    'bad_gender'=>'If the function were performed badly, would it affect <u>men and women</u> differently?',
    'bad_sexual_orientation'=>'f the function were performed badly, would it affect people of different <u>sexual orientation</u> differently?',
    'bad_faith'=>'If the function were performed badly, would it affect different <u>faith groups</u> differently?',
    'bad_ability'=>'If the function were performed badly, would it affect <u>people with different kinds of disabilities</u> differently?'
    }
end
