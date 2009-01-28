#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class HelpText < ActiveRecord::Base
  def self.hashes
    @@Hashes
  end
  
  def can_be_edited_by?(user_)
    user_.class == Administrator
  end
  
  def self.can_be_viewed_by?(user_)
    user_.class == Administrator
  end
end
