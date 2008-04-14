class Question < ActiveRecord::Base
  belongs_to :activity
  has_one :comment, :dependent => :destroy
  has_one :note, :dependent => :destroy
  validates_uniqueness_of :name, :scope => :activity_id
  attr_reader :section, :strand, :number
  
  def after_initialize
    @section, @strand, @number = Activity.question_separation(self.name)
  end
  
end
