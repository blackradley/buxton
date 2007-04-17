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
# Display the users progress through the questions
#
  def progress_bar(percentage)
    html = "<table border='0' cellpadding='0' cellSpacing='0' bgColor='Red'>"
    html += "<tr>"
    html += "<td width='100'><img src='../images/bar.gif' width='#{percentage}' height='10px'></td>"
    html += "</tr>"
    html += "</table>"
  end
#
# Radio buttons for look ups
#
  def radio_look_ups(lookups)

  end
end
