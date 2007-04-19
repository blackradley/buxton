# 
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
module FunctionHelper
#
# Show a tick or cross, if the function is approved or not
#
  def approved_tag(is_ticked)
    if is_ticked
      return '<img src="../images/tick.gif" title="Approved"/>'
    else
      return '<img src="../images/cross.gif" title="Not approved yet"/>'
    end
  end
#
# Radio buttons for look ups
#
  def radio_look_ups(lookups)

  end
end
