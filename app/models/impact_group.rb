#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class ImpactGroup < ActiveRecord::Base
  belongs_to :organisation
  validates_presence_of :name
  validates_numericality_of :display_order
  
end
