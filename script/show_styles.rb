#  
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserve. 
#
# A faintly ludicious method of controlling IE to show the pages we
# want to review for the styles.
#
require 'win32ole'

def wait_for_IE(ie) 
  sleep(1) until ie.Busy == false #wait until the page arrives
  sleep(1) until ie.ReadyState == 4 #wait until ready state indicates complete
end

ie = WIN32OLE.new('InternetExplorer.Application')
ie.Visible = true
ie.Navigate('http://google.com')
wait_for_IE(ie) 
ie.Document.All.q.Value = 'ruby on windows'
ie.Document.All.btnG.click
wait_for_IE(ie) 

#ie.Quit


