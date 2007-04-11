#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Notifier < ActionMailer::Base

  FROM = 'equality_support@blackradley.com'
  
  def administration_key(user)
    @subject      = 'New Administration Key'
    @body["user"] = user
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now
    @headers      = {}
  end
  
  def organisation_key(user, organisation)
    @subject      = 'New Organisation Key'
    @body["user"] = user
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now
    @headers      = {}
  end
  
  def function_key(user, function)
    @subject      = 'New Function Key'
    @body["user"] = user
    @recipients   = user.email
    @from         = FROM
    @sent_on      = Time.now
    @headers      = {}
  end
  
  
end
