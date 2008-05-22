#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class OrganisationStrategy < Strategy
  belongs_to :organisation
  attr_accessor :should_destroy
  acts_as_list :scope => :organisation

  def should_destroy?
    should_destroy.to_i == 1
  end

  def after_create
    self.organisation.activities.each do |activity|
      activity.activity_strategies.build(:strategy_id => self.id, :strategy_response => 0).save
    end
  end
end
