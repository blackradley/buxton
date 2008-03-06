class Question < ActiveRecord::Base
  belongs_to :activity
  has_one :comment, :dependent => :destroy
  has_one :note, :dependent => :destroy
  validates_uniqueness_of :name, :scope => :activity_id
end
