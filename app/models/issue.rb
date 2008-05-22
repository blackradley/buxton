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

  def after_save
    self.destroy if self.issue_destroy?
  end

  def issue_destroy?
    issue_destroy.to_i == 1
  end

  def check_response(response) #Check response verifies whether a response to a question is correct or not.
    checker = !(response.to_i == 0)
    checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
    return checker
  end
  
  def check_responses
    Issue.content_columns.each do |cc|
      return false unless self.check_response(self.send(cc.name.to_sym))
    end
    return true
  end
  
  def percentage_answered
    total = Issue.content_columns.size - 2
    answered = 0
    Issue.content_columns.each do |cc|
      answered += 1 if cc.name.to_sym != :strand && cc.name.to_sym != :section && self.check_response(self.send(cc.name.to_sym))
    end
    answered.to_f/total 
  end
end
