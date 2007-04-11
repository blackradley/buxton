#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Organisation < ActiveRecord::Base
  belongs_to :user
  has_many :functions
  validates_presence_of :email
  validates_format_of :email,
  :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
  :message => 'email must be valid'
  
end
