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
#27-Stars Joe: This is what is called to interface with the private methods. Doesn't contain much actual functionality
#
  def percentage_answered(section = nil, strand = nil)	 
    if ((!strand) && (section)) then
      total = 0
      $questions[section].each_key{|newstrand| (total += section_percentage_answered(section, newstrand) )if newstrand}
      return total/$questions[section].size
    end
    unless section then
      total = 0
      questions = 0
      $questions.each{|section_name, section_variables| section_variables.each_key{|strand_name| total += section_percentage_answered(section_name, strand_name); questions += 1}}
      return (total/questions)
    end
    if strand && section then return section_percentage_answered(section, strand) end
  end
  
  def started(section = nil, strand = nil)
    if ((!strand) && (section)) then
      total = 0
      $questions[section].each_key{|newstrand| (total += section_percentage_answered(section, newstrand) )if newstrand}
      return total/$questions[section].size
    end
    unless section then
      total = 0
      questions = 0
      $questions.each{|section_name, section_variables| section_variables.each_key{|strand_name| total += section_percentage_answered(section_name, strand_name); questions += 1}}
      return (total/questions)
    end	  
    (percentage_answered(section, strand) > 0)
  end
  
  def completed(section = nil, strand = nil)
    if ((!strand) && (section)) then
      total = 0
      $questions[section].each_key{|newstrand| (total += section_percentage_answered(section, newstrand) )if newstrand}
      return total/$questions[section].size
    end
    unless section then
      total = 0
      questions = 0
      $questions.each{|section_name, section_variables| section_variables.each_key{|strand_name| total += section_percentage_answered(section_name, strand_name); questions += 1}}
      return (total/questions)
    end
    (percentage_answered(section, strand) == 100)    
  end
  
  def statistics
    return nil unless completed # Don't calculate stats if all the necessary questions haven't been answered
    questions = {}
    $questions.each{|sectionname, section| questions[sectionname] = section} #add sections
    questions.each{|section_name, section_values| section_values.each {|strand_name, strand_value| questions[section_name][strand_name] = strand_value}}
    questions.each do |section_name, section_values| 
	    section_values.each do |strand_name, strand_values| 
		    strand_values.each do |question, value| 
			    questions[section_name][strand_name][question] = send("#{section_name}_#{strand_name}_#{question}".to_sym)
		    end
	    end
    end
    test = Statistics.new
    test.score(questions)
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
#27 stars Joe: Removed specific section code, turned it into a generic section format.
#Must go back and comment code. 
  def section_percentage_answered(section, strand)
    sec_questions = []
    number_answered = 0
    total = 0
    $questions[section][strand].each_key{|question| sec_questions.push("#{section}_#{strand}_#{question}".to_sym)}
    sec_questions.each{|question| if check_question(question) then number_answered += 1; total += 1 else total += 1 end}
    return ((Float(number_answered)/total)*100).round
  end

  def check_question(question)
      # What does an answer of 'Yes' correspond to?
      yes_value = LookUp.yes_no_notsure.find{|lookUp| 'Yes' == lookUp.name}.value 
      #What does an answer of 'No' correspond to?
      no_value = LookUp.yes_no_notsure.find{|lookUp| 'No' == lookUp.name}.value 
    @dependent_questions = { :performance_overall_3 => [[:performance_overall_2, yes_value]],
                            :performance_overall_5 => [[:performance_overall_4, yes_value]],
                            :performance_gender_3 => [[:performance_gender_2, yes_value ]],
                            :performance_gender_5 => [[:performance_gender_4, yes_value]],
                            :performance_race_3 => [[:performance_race_2, yes_value]],
                            :performance_race_5 => [[:performance_race_4,  yes_value]],
                            :performance_disability_3 => [[:performance_disability_2, yes_value]],
                            :performance_disability_5 => [[:performance_disability_4,  yes_value]],
                            :performance_faith_3 => [[:performance_faith_2, yes_value]],
                            :performance_faith_5 => [[:performance_faith_4, yes_value]],
                            :performance_sexual_orientation_3 => [[:performance_sexual_orientation_2, yes_value]],
                            :performance_sexual_orientation_5 => [[:performance_sexual_orientation_4, yes_value]],
                            :performance_age_3 => [[:performance_age_2, yes_value]],
                            :performance_age_5 => [[:performance_age_4, yes_value]],
			    :confidence_consultation_gender_2 => [[:confidence_consultation_gender_1, no_value]],
			    :confidence_consultation_gender_3 => [[:confidence_consultation_gender_1, yes_value]],
			    :confidence_consultation_gender_5 => [[:confidence_consultation_gender_4, no_value]],
			    :confidence_consultation_gender_6 => [[:confidence_consultation_gender_4, yes_value]],
			    :confidence_consultation_gender_8 => [[:confidence_consultation_gender_7, yes_value]],
			    :confidence_consultation_age_2 => [[:confidence_consultation_age_1, no_value]],
			    :confidence_consultation_age_3 => [[:confidence_consultation_age_1, yes_value]],
			    :confidence_consultation_age_5 => [[:confidence_consultation_age_4, no_value]],
			    :confidence_consultation_age_6 => [[:confidence_consultation_age_4, yes_value]],
			    :confidence_consultation_age_8 => [[:confidence_consultation_age_7, yes_value]],
			    :confidence_consultation_disability_2 => [[:confidence_consultation_disability_1, no_value]],
			    :confidence_consultation_disability_3 => [[:confidence_consultation_disability_1, yes_value]],
			    :confidence_consultation_disability_5 => [[:confidence_consultation_disability_4, no_value]],
			    :confidence_consultation_disability_6 => [[:confidence_consultation_disability_4, yes_value]],
			    :confidence_consultation_disability_8 => [[:confidence_consultation_disability_7, yes_value]],
			    :confidence_consultation_race_2 => [[:confidence_consultation_race_1, no_value]],
			    :confidence_consultation_race_3 => [[:confidence_consultation_race_1, yes_value]],
			    :confidence_consultation_race_5 => [[:confidence_consultation_race_4, no_value]],
			    :confidence_consultation_race_6 => [[:confidence_consultation_race_4, yes_value]],
			    :confidence_consultation_race_8 => [[:confidence_consultation_race_7, yes_value]],
			    :confidence_consultation_faith_2 => [[:confidence_consultation_faith_1, no_value]],
			    :confidence_consultation_faith_3 => [[:confidence_consultation_faith_1, yes_value]],
			    :confidence_consultation_faith_5 => [[:confidence_consultation_faith_4, no_value]],
			    :confidence_consultation_faith_6 => [[:confidence_consultation_faith_4, yes_value]],
			    :confidence_consultation_faith_8 => [[:confidence_consultation_faith_7, yes_value]],
			    :confidence_consultation_sexual_orientation_2 => [[:confidence_consultation_sexual_orientation_1, no_value]],
			    :confidence_consultation_sexual_orientation_3 => [[:confidence_consultation_sexual_orientation_1, yes_value]],
			    :confidence_consultation_sexual_orientation_5 => [[:confidence_consultation_sexual_orientation_4, no_value]],
			    :confidence_consultation_sexual_orientation_6 => [[:confidence_consultation_sexual_orientation_4, yes_value]],
			    :confidence_consultation_sexual_orientation_8 => [[:confidence_consultation_sexual_orientation_7, yes_value]],
			    :confidence_information_race_3 => [[:confidence_information_race_2, yes_value]],
			    :confidence_information_disability_3 => [[:confidence_information_disability_2, yes_value]],
			    :confidence_information_faith_3 => [[:confidence_information_faith_2, yes_value]],
			    :confidence_information_overall_3 => [[:confidence_information_overall_2, yes_value]],
			    :confidence_information_sexual_orientation_3 => [[:confidence_information_sexual_orientation_2, yes_value]],
			    :confidence_information_age_3 => [[:confidence_information_age_2, yes_value]],
			    :confidence_information_gender_3 => [[:confidence_information_gender_2, yes_value]],
			    :confidence_information_race_5 => [[:confidence_information_race_4, yes_value]],
			    :confidence_information_disability_5 => [[:confidence_information_disability_4, yes_value]],
			    :confidence_information_faith_5 => [[:confidence_information_faith_4, yes_value]],
			    :confidence_information_overall_5 => [[:confidence_information_overall_4, yes_value]],
			    :confidence_information_sexual_orientation_5 => [[:confidence_information_sexual_orientation_4, yes_value]],
			    :confidence_information_age_5 => [[:confidence_information_age_4, yes_value]],
			    :confidence_information_gender_5 => [[:confidence_information_gender_4, yes_value]],
			    :additional_work_race_8 => [[:additional_work_race_7, yes_value]],
			    :additional_work_disability_8 => [[:additional_work_disability_7, yes_value]],
			    :additional_work_faith_8 => [[:additional_work_faith_7, yes_value]],
			    :additional_work_overall_8 => [[:additional_work_overall_7, yes_value]],
			    :additional_work_sexual_orientation_8 => [[:additional_work_sexual_orientation_7, yes_value]],
			    :additional_work_age_8 => [[:additional_work_age_7, yes_value]],
			    :additional_work_gender_8 => [[:additional_work_gender_7, yes_value]],
			    :additional_work_race_6 => [[:additional_work_race_5, yes_value]],
			    :additional_work_disability_6 => [[:additional_work_disability_5, yes_value]],
			    :additional_work_faith_6 => [[:additional_work_faith_5, yes_value]],
			    :additional_work_overall_6 => [[:additional_work_overall_5, yes_value]],
			    :additional_work_sexual_orientation_6 => [[:additional_work_sexual_orientation_5, yes_value]],
			    :additional_work_age_6 => [[:additional_work_age_5, yes_value]],
			    :additional_work_gender_6 => [[:additional_work_gender_5, yes_value]]
                            }
    dependency = @dependent_questions[question]
    if dependency then
      response = send(question)
      dependant_correct = true
      dependency.each{|dependent| dependant_correct = dependant_correct && !(send(dependent[0])==dependent[1])}
      if dependant_correct then
	return true 
      else 
	return (check_response(response))
      end
    else
      response = send(question)
      return check_response(response)
    end
  end
  
  def check_response(response)
    checker = !(response.to_i == 0)
    checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
    return checker
  end
  
end