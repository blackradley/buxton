# 
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
# The notifier sends out new "unique" URLs to the different users.  The users
# can then click on the link to get to the page they need to fill in.  No user
# names or passwords to remember, but quite insecure.  Then again no one 
# remembers the user names and passwords so they are a hassle.  It is all a 
# bit of a compromise between hassle and security.
#
# Unlike controllers from Action Pack, the mailer instance doesn‘t have any 
# context about the incoming request.  So the request is passed in explicitly
# to each of the methods.
class Notifier < ActionMailer::Base
#
# Constant for the origin of all the emails.
#
  FROM = 'equality_support@blackradley.com'
#
# A new key for the system administrator
#
  def administration_key(user, request)
    @subject      = 'New Administration Key'
    email_details(user, request)
  end
#
# A new key for the organisation administrator
#
  def organisation_key(user, request)
    @subject      = 'New Organisation Key for ' + user.organisation.name
    email_details(user, request)
  end
#
# Request a new key for the function manager
#
  def function_key(user, request)
    @subject      = 'New Function Key for ' + user.function.name
    email_details(user, request)
  end
#
# Set the bits and pieces in the email
#
private
  def email_details(user, request)
    @body         = {"user" => user, "request" => request}
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now
    @headers      = {}
    # @content_type = "text/html"
  end
end
