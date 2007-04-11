#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Notifier < ActionMailer::Base

  def new_key(user)
    @subject      = 'New Key'
    @body["user"] = user
    @recipients   = 'drbollins@hotmail.com'
    @from         = 'equality@blackradley.com'
    @sent_on      = Time.now
    @headers      = {}
  end
end
