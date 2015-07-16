class TaskGroupMembership < ActiveRecord::Base
  attr_protected
  belongs_to :activity
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => :activity_id
end
