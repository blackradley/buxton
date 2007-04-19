#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Organisation < ActiveRecord::Base
  belongs_to :user
  has_many :functions
  
#
# Retun a float for the percentage of questions answered
#
  def percentage_completed
  # TODO: Calculate the percentage of questions answered
  # Some monkeying with SQL might come up with something suitable
    return rand(100)
  end
end
