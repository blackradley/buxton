# 
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
# All the drop down lists and stuff like that are supplied from a
# single table of look ups.  The look ups are then selected using
# a constant.  Static methods are then used to get an array of 
# LookUps.  These methods seem to return an array rather than an
# ActiveRecord type table, which makes finding an item in the list
# a bit fiddly.  I am sure that I am missing something here.
#  
class LookUp < ActiveRecord::Base
  validates_presence_of :name
# 
# Constants to be used for the different types of look ups.
#  
  TYPE = {:yes_no => 0, 
    :agree_disagree => 1, 
    :existing_proposed => 2, 
    :impact_amount => 3,
    :impact_level => 4,
    :priority => 5}
#
# Yes or no, <tt>self</tt> makes it static
# 
  def self.yes_no()
    return find_all_by_look_up_type(TYPE[:yes_no])
  end
#
# Levels of agreement.
#
  def self.agree_disagree()
    return find_all_by_look_up_type(TYPE[:agree_disagree])
  end
#
# Is the function exisiting or proposed.
#
  def self.existing_proposed()
    return find_all_by_look_up_type(TYPE[:existing_proposed])
  end
#
# A more precise (well ish) amount of impact.
#
  def self.impact_amount()
    return find_all_by_look_up_type(TYPE[:impact_amount])
  end
#
# Gross levels of impact, like is it in or out.
#
  def self.impact_level()
    return find_all_by_look_up_type(TYPE[:impact_level])
  end
end
