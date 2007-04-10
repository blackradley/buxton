#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class UserWithType < ActiveRecord::Base
  has_one :organisation
  has_one :function
end

