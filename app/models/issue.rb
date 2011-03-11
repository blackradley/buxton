#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/issue.rb $
# $Rev: 370 $
# $Author: 27Stars-Joe $
# $Date: 2007-10-28 12:13:39 +0100 (Tue, 18 Oct 2007) $
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
# An issue is an item that requires an action plan, and is specified in consultation sections.
# Each strand has it's own issues, and these issues get taken into account in completed tags and dependent activities.
class Issue < ActiveRecord::Base
	belongs_to :activity
  validates_presence_of :description
  attr_accessor :issue_destroy
  
  include FixInvalidChars
  
  before_save :fix_fields
  after_save :destroy_if_issue_destroy
  
  def fix_fields
    self.attributes.each_pair do |key, value|
      self.attributes[key] = fix_field(value)
    end
  end
  
  def can_be_edited_by?(user_)
    [ActivityManager, ActivityApprover].include?(user_.class) && user_.activity == self
  end
  
  def self.can_be_viewed_by?(user_)
    [ActivityManager, ActivityApprover].include? user_.class
  end

  def destroy_if_issue_destroy
    self.destroy if self.issue_destroy?
  end

  def issue_destroy?
    issue_destroy.to_i == 1
  end

  def check_response(response) #Check response verifies whether a response to a question is correct or not.
    return (response.to_s.length > 0)
  end
  
  def check_responses
    Issue.content_columns.each do |cc|
      return false unless self.check_response(self.send(cc.name.to_sym))
    end
    return true
  end
  
  def percentage_answered
    # 2 = 2 columns we don't need (strand and section)
    total = Issue.content_columns.size - 2
    answered = 0
    Issue.content_columns.each do |cc|
      answered += 1 if cc.name.to_sym != :strand && cc.name.to_sym != :section && self.check_response(self.send(cc.name.to_sym))
    end
    answered.to_f/total 
  end
end
