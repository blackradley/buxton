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
# TODO: Traffic light status
#
  def relevance_status
    if read_attribute(:existence_status) == 9
      return 'High'
    else
      if relevance > 0
        return 'Low'
      else
        return 'Medium'
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
# The percentage answered for section 1
#
  def section1_percentage_answered     
    number_of_questions = 20.0 # decimal point prevents rounding
    questions_answered = read_attribute(:existence_status) > 0 ? 1 : 0
    questions_answered += read_attribute(:impact_service_users) > 0 ? 1 : 0
    questions_answered += read_attribute(:impact_staff) > 0 ? 1 : 0
    questions_answered += read_attribute(:impact_supplier_staff) > 0 ? 1 : 0
    questions_answered += read_attribute(:impact_partner_staff) > 0 ? 1 : 0
    questions_answered += read_attribute(:impact_employees) > 0 ? 1 : 0
    questions_answered += read_attribute(:good_gender) > 0 ? 1 : 0
    questions_answered += read_attribute(:good_race) > 0 ? 1 : 0
    questions_answered += read_attribute(:good_disability) > 0 ? 1 : 0
    questions_answered += read_attribute(:good_faith) > 0 ? 1 : 0
    questions_answered += read_attribute(:good_sexual_orientation) > 0 ? 1 : 0
    questions_answered += read_attribute(:good_age) > 0 ? 1 : 0
    questions_answered += read_attribute(:bad_gender) > 0 ? 1 : 0
    questions_answered += read_attribute(:bad_race) > 0 ? 1 : 0
    questions_answered += read_attribute(:bad_disability) > 0 ? 1 : 0
    questions_answered += read_attribute(:bad_faith) > 0 ? 1 : 0
    questions_answered += read_attribute(:bad_sexual_orientation) > 0 ? 1 : 0
    questions_answered += read_attribute(:bad_age) > 0 ? 1 : 0
    questions_answered += read_attribute(:is_approved).to_i 
    questions_answered += read_attribute(:approver).blank? ? 0 : 1
    return (questions_answered / number_of_questions) * 100
  end 
end
