#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Note < ActiveRecord::Base
  belongs_to :question
  belongs_to :activity_strategy
  
  include FixInvalidChars
  
  def before_save
    self.contents = fix_field(self.contents)
  end
  
  def self.can_be_viewed_by?(user_)
    [ActivityManager, ActivityApprover].include? user_.class
  end
end
