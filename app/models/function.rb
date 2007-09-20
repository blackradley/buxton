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
# Functions are identifed by their name, which does not have to be unique but
# it might be a good idea since the Organisation manager will use the name
# to identify the function.
# 
# When a function is created a single User is created for it at the same time,
# who is listed in the user table.  If the same person (as identified by their
# email address) is the function manager for a number of functions then they
# are entered many time into the User table.  You could have a list of users
# and a list of functions and then attach users to functions.  This seemed 
# inappropriately complicated since it requires the Organisation manager to
# manage two separate lists and then join them together.
# 
# The functions are supposed to contributed to organisational goals or
# strategies hence they link to a FunctionStrategy.  This is not a "has many 
# and belongs to" where the intervening table would be transparent, because we 
# want to store a value in the function_strategy table of how much of a contribution
# is being made to the strategy.
# 
# Neither is a "has many: through" used because like the "has many and belongs to"
# it is not really a many to many relationship.  Each Strategy is owned by 
# the Organisation, and each Function then contributes (or doesn't contribute) to
# each of the strategies.  The strategy list for each function within an organisation
# is always the same, and the response is stored in the function_strategy table.
# 
class Function < ActiveRecord::Base
  validates_presence_of :name,
    :message => 'All functions must have a name'
  belongs_to :user
  validates_presence_of :user
  validates_associated :user
  belongs_to :organisation
  validates_presence_of :organisation
  validates_associated :organisation
  has_many :function_strategies
  
# 
# Calculates the percentage of questions answered for a specific section in a function or for the
# function as a whole. Almost just a proxy method really that uses some private methods for the actual calculations.
# 
  def percentage_answered(section = nil)
    unless section
      return (section_purpose_percentage_answered() +
                            section_performance_percentage_answered()) / 2
    else
      case section
      when :purpose
        return section_purpose_percentage_answered()
      when :performance
        return section_performance_percentage_answered()
      else
        # Shouldn't get here - if you have, there's a new section that hasn't been fully implemented
        # as it needs tending to here and at the start of the method for the overall calculation.
        # TODO: throw a wobbly
      end
    end
  end
  
  def started(section = nil)
    (percentage_answered(section) > 0)
  end
  
  def completed(section = nil)
    (percentage_answered(section) == 100)    
  end
  
  def statistics
    return nil unless completed # Don't calculate stats if all the necessary questions haven't been answered
    
    stats_questions = [ :existence_status, :good_gender, :good_race, :good_disability, :good_faith, :good_sexual_orientation, 
    :good_age, :bad_gender, :bad_race, :bad_disability, :bad_faith, :bad_sexual_orientation, :bad_age, :overall_performance, 
    :overall_validated, :overall_issues, :gender_performance, :gender_validated, :gender_issues, :race_performance, 
    :race_validated, :race_issues, :disability_performance, :disability_validated, :disability_issues, :faith_performance, 
    :faith_validated, :faith_issues, :sexual_orientation_performance, :sexual_orientation_validated, :sexual_orientation_issues, 
    :age_performance, :age_validated, :age_issues ]
    
    answers = {}
    
    stats_questions.each do |q|
      answer = send(q)
      
      weight = case $questions[q][1]
      when :existing_proposed
        LookUp.existing_proposed.find{|lookUp| answer == lookUp.value}.weight
      when :impact_amount
        LookUp.impact_amount.find{|lookUp| answer == lookUp.value}.weight
      when :impact_level
        LookUp.impact_level.find{|lookUp| answer == lookUp.value}.weight
      when :rating
        LookUp.rating.find{|lookUp| answer == lookUp.value}.weight
      when :yes_no_notsure
        LookUp.yes_no_notsure.find{|lookUp| answer == lookUp.value}.weight
      end      
      
      answers[q] = weight
    end
    
    test = Statistics.new
    test.score(answers)
    test.function
  end
  
    
  # K: TODO
  # def destroy
  #   deleted_on = Time.now
  #   save
  # end
  
  # K: TODO
  # def self.find(*args)
  #   self.with_scope(:find => { :conditions => 'deleted_on IS NULL' }) { super(*args) }
  # end

private

# The percentage number of questions answered for section 1 (the relevance
# test).  Originally this was part of the model but it has to make use of
# the Strategy table as well, which was inconvenient from the model.  Also
# you could argue that the number of questions answered is an external and
# arbitary value not inherent in the model.  In a way it is something that 
# is calculated based on the model, which is what happens here.
# 
# To prevent rounding occuring during the calculation (which would happen
# because all the values are integers) the number of questions is given with
# a decimal place to make it a float.  This seems a bit naff to me, I think
# there should be a neater way, but Ruby isn't my strongest skill.
#
  def section_purpose_percentage_answered  
    number_of_questions = 20.0 + organisation.strategies.count # decimal point prevents rounding
    questions_answered = existence_status > 0 ? 1 : 0
    questions_answered += impact_service_users > 0 ? 1 : 0
    questions_answered += impact_staff > 0 ? 1 : 0
    questions_answered += impact_supplier_staff > 0 ? 1 : 0
    questions_answered += impact_partner_staff > 0 ? 1 : 0
    questions_answered += impact_employees > 0 ? 1 : 0
    questions_answered += good_gender > 0 ? 1 : 0
    questions_answered += good_race > 0 ? 1 : 0
    questions_answered += good_disability > 0 ? 1 : 0
    questions_answered += good_faith > 0 ? 1 : 0
    questions_answered += good_sexual_orientation > 0 ? 1 : 0
    questions_answered += good_age > 0 ? 1 : 0
    questions_answered += bad_gender > 0 ? 1 : 0
    questions_answered += bad_race > 0 ? 1 : 0
    questions_answered += bad_disability > 0 ? 1 : 0
    questions_answered += bad_faith > 0 ? 1 : 0
    questions_answered += bad_sexual_orientation > 0 ? 1 : 0
    questions_answered += bad_age > 0 ? 1 : 0
    questions_answered += approved.to_i 
    questions_answered += approver.blank? ? 0 : 1
    function_strategies.each do |strategy|
      questions_answered += strategy.strategy_response > 0 ? 1 : 0
    end
    percentage = (questions_answered / number_of_questions) * 100 # calculate
    percentage = percentage.round # round to one decimal place
    return percentage
  end

# 
# Calculates the percentage of questions answered in the performance section
# Note: currently assumes that the textareas do not need filling in to be complete.
# 
  def section_performance_percentage_answered

    # All the questions, in function, that are in the performance section
    performance_questions = [ :overall_performance,
                              :overall_validated,
                              :overall_issues,
                              :gender_performance,
                              :gender_validated,
                              :gender_issues,
                              :race_performance,
                              :race_validated,
                              :race_issues,
                              :disability_performance,
                              :disability_validated,
                              :disability_issues,
                              :faith_performance,
                              :faith_validated,
                              :faith_issues,
                              :sexual_orientation_performance,
                              :sexual_orientation_validated,
                              :sexual_orientation_issues,
                              :age_performance,
                              :age_validated,
                              :age_issues ]

    # How many questions is this?
    number_of_questions = performance_questions.size

    # How many are answered?
    questions_answered = performance_questions.inject(0.to_f) { |answered, question|
      # If there's an answer, add 1 to our accumulator else just add 0.
      answered += (send(question) > 0) ? 1 : 0
    }

    # What percentage does this make?
    percentage = (questions_answered / number_of_questions) * 100 # calculate
    percentage = percentage.round # round to one decimal place

    return percentage
  end
  
end