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
    :priority => 5,
    :rating => 6,
    :yes_no_notsure => 7,
    :timescales => 8,
    :consult_groups => 9,
    :consult_experts => 10,
    :yes_no_notsure_10_0 =>11,
    :yes_no_notsure_n5_0 => 12,
    :yes_no_notsure_3_10 => 13,
    :yes_no_notsure_2_5 => 14,
    :yes_no_notsure_15_0 => 15,
    :yes_no_notsure_3_0 => 16
    }
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
# Is this a function or a policy?
#
  def self.function_policy()
    return find_all_by_look_up_type(TYPE[:function_policy])
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
#
# Rating from 5 (excellent) to 1 (poor)
#
  def self.rating()
    return find_all_by_look_up_type(TYPE[:rating])
  end
#
# Yes / no / not sure
# 
  def self.yes_no_notsure()
    return find_all_by_look_up_type(TYPE[:yes_no_notsure])
  end
#
# Timescales
# 
  def self.timescales()
    return find_all_by_look_up_type(TYPE[:timescales])
  end
#
# Groups
# 
  def self.consult_groups()
    return find_all_by_look_up_type(TYPE[:consult_groups])
  end
#
# Experts
# 
  def self.consult_experts()
    return find_all_by_look_up_type(TYPE[:consult_experts])
  end
#
# Yes/no 10/0
#
  def self.yes_no_notsure_10_0
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_10_0])
  end
#
#yes/no/ -5/0
#
  def self.yes_no_notsure_n5_0
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_n5_0])
  end

#
#yes/no -3/0
#
  def self.yes_no_notsure_n3_0
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_n3_0])
  end

#
#yes/no 3/10
#

  def self.yes_no_notsure_3_10
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_3_10])
  end

#
#yes/no 2/5
#

  def self.yes_no_notsure_2_5
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_2_5])
  end

#
#yes/no 15/0
#

  def self.yes_no_notsure_15_0
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_15_0])
  end

#
#yes/no 3/0
#
  def self.yes_no_notsure_3_0
    return find_all_by_look_up_type(TYPE[:yes_no_notsure_3_0])
  end
end