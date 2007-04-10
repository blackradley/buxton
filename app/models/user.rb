#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
# A user may be one of three types. 
# * Administrative - the user has now function or organisation
# * Organisational - the user controls an organisation
# * Functional - the user controls a function
# These groups are mutually exclusive.
# 
class User < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :function
  
 # Administrative users have no organisation or function to control. 
  def self.find_admins
    find(:all)
  end
end
