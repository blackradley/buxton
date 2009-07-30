#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class DestroyLog < Log  
  ICON = 'icons/delete.png'
  
  def details
    det = LogDetails.new
    activity = /The <strong>(.*)<\/strong> activity/.match(self.message)[1].gsub('"', '').gsub("'", '')
    organisation = /for <strong>(.*)<\/strong> was deleted/.match(self.message)[1].gsub('"', '').gsub("'", '')
    det[:user] = 'unknown'
    det[:level] = 'organisation'
    det[:organisation] = organisation
    det[:action] = "#{activity} deleted."
    return det
  end
end