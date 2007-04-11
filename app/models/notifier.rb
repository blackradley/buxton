#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Notifier < ActionMailer::Base

  def new_key(sent_at = Time.now)
    @subject    = 'Notifier#new_key'
    @body       = {}
    @recipients = 'drbollins@hotmail.com'
    @from       = 'equality@blackradley.com'
    @sent_on    = sent_at
    @headers    = {}
  end
end
