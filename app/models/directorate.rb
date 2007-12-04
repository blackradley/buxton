class Directorate < ActiveRecord::Base
  belongs_to :organisation
  has_many :activities
  validates_uniqueness_of :name, :scope => :organisation_id
end
