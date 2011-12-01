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

  def response
    if self.input_type == "select"
      self.raw_answer.to_i
    else
      self.raw_answer
    end
  end
    
  def display_response
    if self.input_type == "select"
      self.choices[self.raw_answer.to_i]
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
    if self.input_type == "select"
      return !(response.to_i == 0)
    else 
      return response.to_s.length > 0
    end
  end
    
  def check_needed
    parent_okay = self.parent.nil? ? true : self.dependency.satisfied?
    parent_okay
  end
  
  def update_status
    self.completed = check_response
    self.needed = check_needed
    true #before and after save rollback if the before/after save returns false!
  end
  
  def update_children
    children.each do |child|
      child.parent.reload
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

  def changed?
    different_answer? || different_comment? || different_note?
  end

  def different_answer?
    return false unless self.activity.previous_activity
    previous_question = self.activity.previous_activity.questions.where(:name => self.name).first
    return previous_question.raw_answer != self.raw_answer 
  end

  def different_comment?
    return false unless self.activity.previous_activity
    previous_question = self.activity.previous_activity.questions.where(:name => self.name).first
    return false if previous_question.comment.nil? && self.comment.nil?
    return false unless previous_question.comment || self.comment
    return previous_question.comment.contents.to_s != self.comment.contents.to_s 
  end

  def different_note?
    return false unless self.activity.previous_activity
    previous_question = self.activity.previous_activity.questions.where(:name => self.name).first
    return false if previous_question.note.nil? && self.note.nil?
    return false unless previous_question.note || self.note
    return previous_question.note.contents != self.note.contents 
  end

  def previous
    return nil unless self.activity.previous_activity
    self.activity.previous_activity.questions.where(:name => self.name).first
  end


end
