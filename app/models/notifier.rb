#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
class Notifier < ActionMailer::Base

  FROM = 'equality_support@blackradley.com'
#
# Unlike controllers from Action Pack, the mailer instance doesnâ€˜t 
# have any context about the incoming request.  So the request is 
# passed in explicitly
#
# A new key for the system administrator
#
  def administration_key(user, request)
    @subject      = 'New Administration Key'
    @body         = {"user" => user, "request" => request}
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now
    @headers      = {}
  end
#
# A new key for the organisation administrator
#
  def organisation_key(user, request)
    @subject      = 'New Organisation Key for ' + user.organisation.name
    email_details(user, request)
  end
#
# A new key for the function administrator
#
  def function_key(user, request)
    @subject      = 'New Function Key for ' + user.function.name
    @body         = {"user" => user, "request" => request}
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now
    @headers      = {}
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
  end
end
