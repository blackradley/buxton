class Directorate < ActiveRecord::Base
  belongs_to :organisation
  has_many :activities
  validates_uniqueness_of :name, :scope => :organisation_id
  # validates_associated :activities
  
  attr_accessor :should_destroy
  
  def should_destroy?
    should_destroy.to_i == 1
  end  
end