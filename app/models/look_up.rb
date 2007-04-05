class LookUp < ActiveRecord::Base
  AGREE_DISAGREE = 1
  
  def self.agree_disagree #self makes it static
    return find_all_by_look_up_type(AGREE_DISAGREE)
  end
  
end
