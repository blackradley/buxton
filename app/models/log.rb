# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class Log < ActiveRecord::Base
  ICON = ''
  
  belongs_to :user
  belongs_to :activity
  
  def icon
    self.class::ICON
  end  
  
  def self.csv
    details_arr = self.all.map(&:details).sort_by(&:user)
  end
  
  def self.can_be_viewed_by?(user_)
    user_.class == Administrator
  end
end