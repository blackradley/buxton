#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Strategy < ActiveRecord::Base
  belongs_to :organisation
  has_and_belongs_to_many :functions
end
