#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Function < ActiveRecord::Base
  belongs_to :user
  belongs_to :organisation
  has_and_belongs_to_many :strategies
#
# Retun a float for the number of questions answered
#
  def percentage_answered
    percentage = 0.0 # the .0 ensures a float is used
    percentage += read_attribute(:relevance01).nil? ? 0.0 : 1.0
    percentage += read_attribute(:relevance02).nil? ? 0.0 : 1.0 
    percentage += read_attribute(:relevance03).nil? ? 0.0 : 1.0 
    percentage = (percentage/30.0)*100
    return percentage
  end
end
