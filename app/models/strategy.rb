# 
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
# 
# Each Organisation has a set of strategies (or priorities) which the functions
# contribute to.  The strategies are typically inane, like "make things nicer" or
# "be excellent to each other".
#
class Strategy < ActiveRecord::Base
  belongs_to :organisation
  has_many :function_strategies
  validates_presence_of :name
  validates_numericality_of :display_order
end
