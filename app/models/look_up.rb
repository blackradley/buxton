#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
class LookUp < ActiveRecord::Base
  YES_NO = 0
  AGREE_DISAGREE = 1
  EXISTING_PROPOSED = 2
  PROPORTION = 3
  
  def self.yes_no #self makes it static
    return find_all_by_look_up_type(YES_NO)
  end
  
  def self.agree_disagree #self makes it static
    return find_all_by_look_up_type(AGREE_DISAGREE)
  end
  
  def self.existing_proposed #self makes it static
    return find_all_by_look_up_type(EXISTING_PROPOSED)
  end
  
  def self.proportion #self makes it static
    return find_all_by_look_up_type(PROPORTION)
  end
  
end
