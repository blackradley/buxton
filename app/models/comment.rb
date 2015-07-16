#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Comment < ActiveRecord::Base
  attr_protected
  belongs_to :question
  belongs_to :activity_strategy

  include FixInvalidChars

  before_save :fix_contents

  delegate :to_s, :to => :contents

  def fix_contents
    self.contents = fix_field(self.contents)
    true
  end

  def html_id
    "comment_#{self.id}"
  end

  def self.can_be_viewed_by?(user_)
    [ActivityManager, ActivityApprover].include? user_.class
  end

end
