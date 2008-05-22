#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class DirectorateStrategy < Strategy
  belongs_to :directorate
  attr_accessor :should_destroy
  acts_as_list :scope => :directorate

  def should_destroy?
    should_destroy.to_i == 1
  end
  
  def after_create
    self.directorate.activities.each do |activity|
      activity.activity_strategies.build(:strategy_id => self.id, :strategy_response => 0).save
    end
  end
  
end
