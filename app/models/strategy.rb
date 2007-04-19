#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Strategy < ActiveRecord::Base
  belongs_to :organisation
  has_and_belongs_to_many :functions
  validates_presence_of :name
  validates_numericality_of :display_order
  
end
