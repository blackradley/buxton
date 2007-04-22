# 
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
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
# Radio buttons for look ups
#
  def radio_look_ups(lookups)

  end
end
