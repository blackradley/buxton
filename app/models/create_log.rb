#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class CreateLog < Log
  
  ICON = 'icons/add.png'
  
  def details
    det = LogDetails.new
    activity = /The <strong>(.*)<\/strong> activity/.match(self.message)[1].gsub('"', '').gsub("'", '')
    organisation = /created for <strong>(.*)<\/strong>/.match(self.message)[1].gsub('"', '').gsub("'", '')
    det[:user] = 'unknown'
    det[:level] = 'organisation'
    det[:organisation] = organisation
    det[:action] = "#{activity} created."
    det[:date] = self.created_at.strftime("%d/%m/%Y")
    det[:time] = self.created_at.strftime("%H:%M")
    return det
  end
end