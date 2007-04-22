#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
class ImpactGroup < ActiveRecord::Base
  belongs_to :organisation
  validates_presence_of :name
  validates_numericality_of :display_order
  
end
