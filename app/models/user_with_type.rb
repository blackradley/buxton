#  
# * $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/user.rb $
# * $Rev: 36 $
# * $Author: BlackRadleyJoe $
# * $Date: 2007-04-10 16:16:19 +0100 (Tue, 10 Apr 2007) $
# 
class UserWithType < ActiveRecord::Base
  has_one :organisation
  has_one :function
end
