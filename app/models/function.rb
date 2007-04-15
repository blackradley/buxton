#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class Function < ActiveRecord::Base
  belongs_to :user
  belongs_to :organisation
  
  def state
    function_state = 0 
    function_state += read_attribute(:relevance01).nil? ? 0 : 1
    function_state += read_attribute(:relevance02).nil? ? 0 : 1 
    function_state += read_attribute(:relevance03).nil? ? 0 : 1 
    return function_state
  end
end
