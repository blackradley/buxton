#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
# 
class Function < ActiveRecord::Base
  belongs_to :user
  belongs_to :organisation
  has_and_belongs_to_many :strategies
  has_many :functions_impact_groups, :dependent => true
  has_many :impact_groups, :through => :functions_impact_groups
  has_and_belongs_to_many :impact_groups
  
  validates_presence_of :name
#
# Bogus percentage answered
#
  def percentage_answered     
    if rand(3)==2
      return 0
    else
      return 25
    end
  end
#
# Bogus traffic light status
#
  def is_red
    if rand(3)==2
      return true
    else
      return false
    end
  end

end
