#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class DirectorateStrategy < Strategy
  belongs_to :directorate
  attr_accessor :should_destroy
  acts_as_list :scope => :directorate
  
  after_create :build_activity_strategies

  def should_destroy?
    should_destroy.to_i == 1
  end
  
  def build_activity_strategies
    self.directorate.activities.each do |activity|
      activity.activity_strategies.build(:strategy_id => self.id, :strategy_response => 0).save
    end
  end
  
end
