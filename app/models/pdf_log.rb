#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class PDFLog < Log
  
  ICON = 'icons/pdf.gif'
  
  def details
    det = {}
    data = /The (.*) manager PDF/.match(self.message)[1].gsub('"', '').gsub("'", '')
    if data = 'activity'
      activity = /<strong>(.*)<\/strong> activity/.match(self.message)[1]
      organisation = /within <strong>(.*)<\/strong>/.match(self.message)[1]
    else
      organisation = /<strong>(.*)<\/strong>/.match(self.message)[1]
    end
    det[:user] = 'unknown'
    det[:level] = data
    det[:organisation] = organisation
    det[:action] = "viewed pdf"
    return det
    end
  end  
end