#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class HelpText < ActiveRecord::Base
  include FixInvalidChars
  attr_protected

  before_save :fix_fields

  def fix_fields
    self.attributes.each_pair do |key, value|
      self.attributes[key] = fix_field(value)
    end
  end

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
