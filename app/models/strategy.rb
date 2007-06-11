#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class Strategy < ActiveRecord::Base
  belongs_to :organisation
  has_many :function_strategies
  validates_presence_of :name
  validates_numericality_of :display_order
end
