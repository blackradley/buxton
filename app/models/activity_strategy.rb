#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
# The FunctionStrategy is used to store responses about how much the Function
# contributes to the Organisation strategies.
#
# Each Organisation has a set of strategies and each Function (well really the
# Activity manager) has to say how much they contribute to each of the strategies.
# So it is not really a many to many relationship.
#
class ActivityStrategy < ActiveRecord::Base
  attr_protected
  belongs_to :activity
  belongs_to :strategy
  has_one :note
  has_one :comment

  after_save :update_purpose

  def update_purpose
    if self.activity.purpose_completed then
      self.activity.update_attributes(:purpose_completed => false) if self.strategy_response == 0
    end
    true
  end

  def changed_in_previous_ea?
    different_answer? || different_comment? || different_note?
  end

  def different_answer?
    return false unless self.activity.previous_activity
    previous_strategy = self.activity.previous_activity.activity_strategies.where(:strategy_id => self.strategy_id).first
    return previous_strategy.try(:strategy_response) != self.strategy_response
  end

  def different_comment?
    return false unless self.activity.previous_activity
    previous_strategy = self.activity.previous_activity.activity_strategies.where(:strategy_id => self.strategy_id).first
    if previous_strategy.try(:comment).blank? || self.comment.blank?
      if self.comment.blank?
        return false
      else
        return true
      end
    end
    return previous_strategy.comment.contents != self.comment.contents
  end

  def different_note?
    return false unless self.activity.previous_activity
    previous_strategy = self.activity.previous_activity.activity_strategies.where(:strategy_id => self.strategy_id).first
    if previous_strategy.try(:note).blank?
      if self.note.blank?
        return false
      else
        return true
      end
    end
    return true if self.note.blank?
    return previous_strategy.note.contents != self.note.contents
  end

  def previous
    return nil unless self.activity.previous_activity
    self.activity.previous_activity.activity_strategies.where(:strategy_id => self.strategy_id).first
  end


end
