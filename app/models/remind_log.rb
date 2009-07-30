#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class RemindLog < Log
  
  ICON = 'icons/remind.gif'
  
  def details
    det = LogDetails.new
    email = /The <strong>(.*)<\/strong> activity/.match(self.message)[1].gsub('"', '').gsub("'", '')
    det[:user] = 'unknown'
    det[:level] = 'admin'
    #det[:organisation] = 
    det[:action] = "Reminder sent"
    return det
  end  
end