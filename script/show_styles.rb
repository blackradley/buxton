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

DEMO_HOST = 'http://www.localhost:3000/'
ORGANISATION_HOST = 'http://birmingham.localhost:3000/'
ie = WIN32OLE.new('InternetExplorer.Application')
ie.Visible = true
ie.height = 600
ie.width = 800

puts 'Demonstration Create Page - press return'
ie.Navigate(DEMO_HOST)
wait_for_IE(ie) 
input = gets

puts 'Demonstration Create with Bogus email - press return'
ie.Document.All.email.Value = 'not an email address'
ie.Document.All.commit.click
input = gets

puts 'CEPT Organisation Control Page - press return'
ie.Document.All.email.Value = 'demo@localhost.com'
ie.Document.All.commit.click
input = gets

puts 'CEPT Section 1 Page - press return'
ie.Document.All.list1.click
input = gets

puts 'CEPT Section 1 view - press return'
ie.Document.All.view(0).click
input = gets

puts 'CEPT Section 1 amend - press return'
ie.Document.All.amend.click
input = gets

# no email error message on /public/function/new

ie.quit

