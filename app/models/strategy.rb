#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# Each Organisation has a set of strategies (or priorities) which the functions
# contribute to.  The strategies are typically inane, like "make things nicer" or
# "be excellent to each other".
#
class Strategy < ActiveRecord::Base
  has_many :activity_strategies
  validates_presence_of :name

end
