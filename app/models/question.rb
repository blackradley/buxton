#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Question < ActiveRecord::Base
  belongs_to :activity
  has_one :comment, :dependent => :destroy
  has_one :note, :dependent => :destroy
  validates_uniqueness_of :name, :scope => :activity_id
  serialize :choices
  has_many :dependencies
  belongs_to :dependency
  before_save :update_status
  after_save :update_children
  # after_save :debug
  # 
  #  
  # def debug
  #   raise self.inspect
  # end
  # 
  def invisible?
    # (@@invisible_questions.include?(self.name.to_sym) && self.activity.proposed?)
  end
  
  def response
    if self.input_type == "select"
      self.raw_answer.to_i
    else
      self.raw_answer
    end
  end
    
  def parent
    self.dependency ? self.dependency.question : nil
  end 
  
  def children
    self.dependencies.map(&:child_question)
  end
    
  def check_response #Check response verifies whether a response to a question is correct or not.
    checker = !(response.to_i == 0)
    checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
    return checker
  end
    
  def check_needed
    parent_okay = self.parent.nil? ? true : self.dependency.satisfied?
    return false if invisible?
    parent_okay
  end
  
  def update_status
    self.completed = check_response
    self.needed = check_needed
    true #before and after save rollback if the before/after save returns false!
  end
  
  def update_children
    children.each do |child|
      child.update_status
      child.save!
    end
    true
  end
  
  def dependency_mapping
    dependency_hash = {}
    self.dependencies.each do |dep|
      dependency_hash.merge!(dep.as_json)
    end
    dependency_hash
  end

end
