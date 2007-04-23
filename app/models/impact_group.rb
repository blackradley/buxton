#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class ImpactGroup < ActiveRecord::Base
  belongs_to :organisation
  has_many :functions_impact_groups, :dependent => true
  has_many :functions, :through => :functions_impact_groups
  validates_presence_of :name
  validates_numericality_of :display_order
  
end
