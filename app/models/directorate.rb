class Directorate < ActiveRecord::Base
  belongs_to :organisation
  has_one :directorate_manager, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  validates_uniqueness_of :name, :scope => :organisation_id
  validates_presence_of :name
  validates_associated :activities
  
  attr_accessor :should_destroy
  
  def should_destroy?
    should_destroy.to_i == 1
  end  
end