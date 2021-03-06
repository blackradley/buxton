#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
# Each Organisation has a set of strategies (or priorities) which the functions
# contribute to.  The strategies are typically inane, like "make things nicer" or
# "be excellent to each other".
#
class Strategy < ActiveRecord::Base
  validates_presence_of :name
  attr_protected

  scope :live, -> {where(retired: false)}
  include FixInvalidChars


end
