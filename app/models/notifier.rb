#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# The notifier sends out new "unique" URLs to the different users.  The users
# can then click on the link to get to the page they need to fill in.  No user
# names or passwords to remember, but quite insecure.  Then again no one
# remembers the user names and passwords so they are a hassle.  It is all a
# bit of a compromise between hassle and security.
# 
class Notifier < ActionMailer::Base
    
  # Constant for the origin of all the emails.
  FROM = 'equality_support@blackradley.com'

  # A new key for the system administrator
  def administration_key(user, login_url)
    @subject      = 'New Administration Key'
    email_details(user, login_url)
  end

  # A new key for the organisation administrator
  def organisation_key(user, login_url)
    @subject      = 'Impact Engine Demonstration Version 2.1'
    email_details(user, login_url)
  end

  # Request a new key for the activity manager
  def activity_key(user, login_url)
    @subject      = 'New Activity Key for ' + user.activity.name
    email_details(user, login_url)
  end

# Set the bits and pieces in the email
private
  def email_details(user, login_url)
    @body         = {"user" => user, "login_url" => login_url}
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now.gmtime
    @headers      = {}
    # @content_type = "text/html"
  end
end
