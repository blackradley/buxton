#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Function < ActiveRecord::Base
  belongs_to :user
  belongs_to :organisation
  validates_presence_of :email  
  validates_format_of :email,
  :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  :message => 'email must be valid'
  
  def state
    read_attribute(:relevance01).nil? ? 0 : 1 +
    read_attribute(:relevance02).nil? ? 0 : 1 +
    read_attribute(:relevance03).nil? ? 0 : 1 +
    read_attribute(:relevance04).nil? ? 0 : 1 +
    read_attribute(:relevance05).nil? ? 0 : 1 +
    read_attribute(:relevance06).nil? ? 0 : 1
  end
end
