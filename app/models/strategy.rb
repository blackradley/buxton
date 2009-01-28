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
  has_many :activity_strategies
  validates_presence_of :name
  
  def can_be_edited_by?(user_)
    user_.class == Administrator
  end
  
  def self.can_be_viewed_by?(user_)
    user_.class == Administrator
  end

end
