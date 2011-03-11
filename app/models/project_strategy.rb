#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class ProjectStrategy < Strategy
  belongs_to :project
  attr_accessor :should_destroy
  acts_as_list :scope => :project
  
  after_create :build_activity_strategies

  def should_destroy?
    should_destroy.to_i == 1
  end

  def build_activity_strategies
    self.project.activities.each do |activity|
      activity.activity_strategies.build(:strategy_id => self.id, :strategy_response => 0).save
    end
  end
  
end
