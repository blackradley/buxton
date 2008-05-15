#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/app/models/issue.rb $
# $Rev: 370 $
# $Author: 27Stars-Joe $
# $Date: 2007-10-28 12:13:39 +0100 (Tue, 18 Oct 2007) $
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# An issue is an item that requires an action plan, and is specified in consultation sections.
# Each strand has it's own issues, and these issues get taken into account in completed tags and dependent activities.
class Issue < ActiveRecord::Base
	belongs_to :activity
  validates_presence_of :description
  attr_accessor :issue_destroy

  def after_save
    self.destroy if self.issue_destroy?
    Issue.content_columns.each do |column|
      if self.activity.overall_completed_issues then
        self.activity.update_attributes(:overall_completed_issues => false, :action_planning_completed => false) unless check_response(self.send(column.name.to_sym))
      end
    end
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
  end
end
