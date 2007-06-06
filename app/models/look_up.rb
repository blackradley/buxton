#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class LookUp < ActiveRecord::Base
  validates_presence_of :name
#
#  Constants for look up types
#  
  TYPE = {:yes_no => 0, 
    :agree_disagree => 1, 
    :existing_proposed => 2, 
    :impact_amount => 3,
    :impact_level => 4,
    :priority => 5}
  
  def self.yes_no #self makes it static
    return find_all_by_look_up_type(TYPE[:yes_no])
  end
  
  def self.agree_disagree #self makes it static
    return find_all_by_look_up_type(TYPE[:agree_disagree])
  end
  
  def self.existing_proposed #self makes it static
    return find_all_by_look_up_type(TYPE[:existing_proposed])
  end
  
  def self.impact_amount #self makes it static
    return find_all_by_look_up_type(TYPE[:impact_amount])
  end
  
  def self.impact_level #self makes it static
    return find_all_by_look_up_type(TYPE[:impact_level])
  end
  
  def self.impact_priority #self makes it static
    return find_all_by_look_up_type(TYPE[:impact_priority])
  end
    
end
