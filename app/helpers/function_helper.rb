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
  def traffic_light_status_tag(is_red)
    if is_red
      return image_tag('red.gif', :alt => "Red", :title => "Red")
    else
      return image_tag('green.gif', :alt => "Green", :title => "Green")
    end
  end

end
