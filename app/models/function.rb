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
  validates_presence_of :user
  validates_associated :user
  belongs_to :organisation
  has_and_belongs_to_many :strategies
  has_many :functions_impact_groups, :dependent => :destroy
  has_many :impact_groups, :through => :functions_impact_groups
  has_and_belongs_to_many :impact_groups
  
  validates_presence_of :name,
    :message => 'All functions must have a name'
#
# Status constants
#
  RED = 3
  AMBER = 2
  GREEN = 1
#
# TODO: Traffic light status
#
  def relevance_status
    if read_attribute(:existence_status) == 9
      return RED
    else
      if relevance > 0
        return GREEN
      else
        return AMBER
      end
    end
  end
#
# TODO: Bogus level of relevance
#
  def relevance
    relevance = read_attribute(:good_gender) +
      read_attribute(:good_race) +
      read_attribute(:good_disability) +
      read_attribute(:good_faith) +
      read_attribute(:good_sexual_orientation) +
      read_attribute(:good_age) +
      read_attribute(:bad_gender) +
      read_attribute(:bad_race) +
      read_attribute(:bad_disability) +
      read_attribute(:bad_faith) +
      read_attribute(:bad_sexual_orientation) +
      read_attribute(:bad_age)
      return relevance
  end
#
# TODO: Bogus percentage answered
#
  def percentage_answered     
    case relevance_status
      when RED
        return 25
      when GREEN
        return 100
      when AMBER
        return 0
    end
  end 
end
