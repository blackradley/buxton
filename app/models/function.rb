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
			    :additional_work_gender_6 => [[:additional_work_gender_5, yes_value]],
			    :action_planning_gender_6 => [[:action_planning_gender_1,""]],
			    :action_planning_gender_7 => [[:action_planning_gender_1,""]],
			    :action_planning_gender_8 => [[:action_planning_gender_1,""]],
			    :action_planning_gender_9 => [[:action_planning_gender_1,""]],
			    :action_planning_gender_31 => [[:action_planning_gender_26,""]],
			    :action_planning_gender_32 => [[:action_planning_gender_26,""]],
			    :action_planning_gender_33 => [[:action_planning_gender_26,""]],
			    :action_planning_gender_34 => [[:action_planning_gender_26,""]],
			    :action_planning_gender_10 => [[:action_planning_gender_2,""]],
			    :action_planning_gender_11 => [[:action_planning_gender_2,""]],
			    :action_planning_gender_12 => [[:action_planning_gender_2,""]],
			    :action_planning_gender_13 => [[:action_planning_gender_2,""]],
			    :action_planning_gender_35 => [[:action_planning_gender_27,""]],
			    :action_planning_gender_36 => [[:action_planning_gender_27,""]],
			    :action_planning_gender_37 => [[:action_planning_gender_27,""]],
			    :action_planning_gender_38 => [[:action_planning_gender_27,""]],
			    :action_planning_gender_14 => [[:action_planning_gender_3,""]],
			    :action_planning_gender_15 => [[:action_planning_gender_3,""]],
			    :action_planning_gender_16 => [[:action_planning_gender_3,""]],
			    :action_planning_gender_17 => [[:action_planning_gender_3,""]],
			    :action_planning_gender_39 => [[:action_planning_gender_28,""]],
			    :action_planning_gender_40 => [[:action_planning_gender_28,""]],
			    :action_planning_gender_41 => [[:action_planning_gender_28,""]],
			    :action_planning_gender_42 => [[:action_planning_gender_28,""]],
			    :action_planning_gender_18 => [[:action_planning_gender_4,""]],
			    :action_planning_gender_19 => [[:action_planning_gender_4,""]],
			    :action_planning_gender_20 => [[:action_planning_gender_4,""]],
			    :action_planning_gender_21 => [[:action_planning_gender_4,""]],
			    :action_planning_gender_43 => [[:action_planning_gender_29,""]],
			    :action_planning_gender_44 => [[:action_planning_gender_29,""]],
			    :action_planning_gender_45 => [[:action_planning_gender_29,""]],
			    :action_planning_gender_46 => [[:action_planning_gender_29,""]],
			    :action_planning_gender_22 => [[:action_planning_gender_5,""]],
			    :action_planning_gender_23 => [[:action_planning_gender_5,""]],
			    :action_planning_gender_24 => [[:action_planning_gender_5,""]],
			    :action_planning_gender_25 => [[:action_planning_gender_5,""]],
			    :action_planning_gender_47 => [[:action_planning_gender_30,""]],
			    :action_planning_gender_48 => [[:action_planning_gender_30,""]],
			    :action_planning_gender_49 => [[:action_planning_gender_30,""]],
			    :action_planning_gender_50 => [[:action_planning_gender_30,""]],
			    :action_planning_race_6 => [[:action_planning_race_1,""]],
			    :action_planning_race_7 => [[:action_planning_race_1,""]],
			    :action_planning_race_8 => [[:action_planning_race_1,""]],
			    :action_planning_race_9 => [[:action_planning_race_1,""]],
			    :action_planning_race_31 => [[:action_planning_race_26,""]],
			    :action_planning_race_32 => [[:action_planning_race_26,""]],
			    :action_planning_race_33 => [[:action_planning_race_26,""]],
			    :action_planning_race_34 => [[:action_planning_race_26,""]],
			    :action_planning_race_10 => [[:action_planning_race_2,""]],
			    :action_planning_race_11 => [[:action_planning_race_2,""]],
			    :action_planning_race_12 => [[:action_planning_race_2,""]],
			    :action_planning_race_13 => [[:action_planning_race_2,""]],
			    :action_planning_race_35 => [[:action_planning_race_27,""]],
			    :action_planning_race_36 => [[:action_planning_race_27,""]],
			    :action_planning_race_37 => [[:action_planning_race_27,""]],
			    :action_planning_race_38 => [[:action_planning_race_27,""]],
			    :action_planning_race_14 => [[:action_planning_race_3,""]],
			    :action_planning_race_15 => [[:action_planning_race_3,""]],
			    :action_planning_race_16 => [[:action_planning_race_3,""]],
			    :action_planning_race_17 => [[:action_planning_race_3,""]],
			    :action_planning_race_39 => [[:action_planning_race_28,""]],
			    :action_planning_race_40 => [[:action_planning_race_28,""]],
			    :action_planning_race_41 => [[:action_planning_race_28,""]],
			    :action_planning_race_42 => [[:action_planning_race_28,""]],
			    :action_planning_race_18 => [[:action_planning_race_4,""]],
			    :action_planning_race_19 => [[:action_planning_race_4,""]],
			    :action_planning_race_20 => [[:action_planning_race_4,""]],
			    :action_planning_race_21 => [[:action_planning_race_4,""]],
			    :action_planning_race_43 => [[:action_planning_race_29,""]],
			    :action_planning_race_44 => [[:action_planning_race_29,""]],
			    :action_planning_race_45 => [[:action_planning_race_29,""]],
			    :action_planning_race_46 => [[:action_planning_race_29,""]],
			    :action_planning_race_22 => [[:action_planning_race_5,""]],
			    :action_planning_race_23 => [[:action_planning_race_5,""]],
			    :action_planning_race_24 => [[:action_planning_race_5,""]],
			    :action_planning_race_25 => [[:action_planning_race_5,""]],
			    :action_planning_race_47 => [[:action_planning_race_30,""]],
			    :action_planning_race_48 => [[:action_planning_race_30,""]],
			    :action_planning_race_49 => [[:action_planning_race_30,""]],
			    :action_planning_race_50 => [[:action_planning_race_30,""]],
			    :action_planning_age_6 => [[:action_planning_age_1,""]],
			    :action_planning_age_7 => [[:action_planning_age_1,""]],
			    :action_planning_age_8 => [[:action_planning_age_1,""]],
			    :action_planning_age_9 => [[:action_planning_age_1,""]],
			    :action_planning_age_31 => [[:action_planning_age_26,""]],
			    :action_planning_age_32 => [[:action_planning_age_26,""]],
			    :action_planning_age_33 => [[:action_planning_age_26,""]],
			    :action_planning_age_34 => [[:action_planning_age_26,""]],
			    :action_planning_age_10 => [[:action_planning_age_2,""]],
			    :action_planning_age_11 => [[:action_planning_age_2,""]],
			    :action_planning_age_12 => [[:action_planning_age_2,""]],
			    :action_planning_age_13 => [[:action_planning_age_2,""]],
			    :action_planning_age_35 => [[:action_planning_age_27,""]],
			    :action_planning_age_36 => [[:action_planning_age_27,""]],
			    :action_planning_age_37 => [[:action_planning_age_27,""]],
			    :action_planning_age_38 => [[:action_planning_age_27,""]],
			    :action_planning_age_14 => [[:action_planning_age_3,""]],
			    :action_planning_age_15 => [[:action_planning_age_3,""]],
			    :action_planning_age_16 => [[:action_planning_age_3,""]],
			    :action_planning_age_17 => [[:action_planning_age_3,""]],
			    :action_planning_age_39 => [[:action_planning_age_28,""]],
			    :action_planning_age_40 => [[:action_planning_age_28,""]],
			    :action_planning_age_41 => [[:action_planning_age_28,""]],
			    :action_planning_age_42 => [[:action_planning_age_28,""]],
			    :action_planning_age_18 => [[:action_planning_age_4,""]],
			    :action_planning_age_19 => [[:action_planning_age_4,""]],
			    :action_planning_age_20 => [[:action_planning_age_4,""]],
			    :action_planning_age_21 => [[:action_planning_age_4,""]],
			    :action_planning_age_43 => [[:action_planning_age_29,""]],
			    :action_planning_age_44 => [[:action_planning_age_29,""]],
			    :action_planning_age_45 => [[:action_planning_age_29,""]],
			    :action_planning_age_46 => [[:action_planning_age_29,""]],
			    :action_planning_age_22 => [[:action_planning_age_5,""]],
			    :action_planning_age_23 => [[:action_planning_age_5,""]],
			    :action_planning_age_24 => [[:action_planning_age_5,""]],
			    :action_planning_age_25 => [[:action_planning_age_5,""]],
			    :action_planning_age_47 => [[:action_planning_age_30,""]],
			    :action_planning_age_48 => [[:action_planning_age_30,""]],
			    :action_planning_age_49 => [[:action_planning_age_30,""]],
			    :action_planning_age_50 => [[:action_planning_age_30,""]],
			    :action_planning_disability_6 => [[:action_planning_disability_1,""]],
			    :action_planning_disability_7 => [[:action_planning_disability_1,""]],
			    :action_planning_disability_8 => [[:action_planning_disability_1,""]],
			    :action_planning_disability_9 => [[:action_planning_disability_1,""]],
			    :action_planning_disability_31 => [[:action_planning_disability_26,""]],
			    :action_planning_disability_32 => [[:action_planning_disability_26,""]],
			    :action_planning_disability_33 => [[:action_planning_disability_26,""]],
			    :action_planning_disability_34 => [[:action_planning_disability_26,""]],
			    :action_planning_disability_10 => [[:action_planning_disability_2,""]],
			    :action_planning_disability_11 => [[:action_planning_disability_2,""]],
			    :action_planning_disability_12 => [[:action_planning_disability_2,""]],
			    :action_planning_disability_13 => [[:action_planning_disability_2,""]],
			    :action_planning_disability_35 => [[:action_planning_disability_27,""]],
			    :action_planning_disability_36 => [[:action_planning_disability_27,""]],
			    :action_planning_disability_37 => [[:action_planning_disability_27,""]],
			    :action_planning_disability_38 => [[:action_planning_disability_27,""]],
			    :action_planning_disability_14 => [[:action_planning_disability_3,""]],
			    :action_planning_disability_15 => [[:action_planning_disability_3,""]],
			    :action_planning_disability_16 => [[:action_planning_disability_3,""]],
			    :action_planning_disability_17 => [[:action_planning_disability_3,""]],
			    :action_planning_disability_39 => [[:action_planning_disability_28,""]],
			    :action_planning_disability_40 => [[:action_planning_disability_28,""]],
			    :action_planning_disability_41 => [[:action_planning_disability_28,""]],
			    :action_planning_disability_42 => [[:action_planning_disability_28,""]],
			    :action_planning_disability_18 => [[:action_planning_disability_4,""]],
			    :action_planning_disability_19 => [[:action_planning_disability_4,""]],
			    :action_planning_disability_20 => [[:action_planning_disability_4,""]],
			    :action_planning_disability_21 => [[:action_planning_disability_4,""]],
			    :action_planning_disability_43 => [[:action_planning_disability_29,""]],
			    :action_planning_disability_44 => [[:action_planning_disability_29,""]],
			    :action_planning_disability_45 => [[:action_planning_disability_29,""]],
			    :action_planning_disability_46 => [[:action_planning_disability_29,""]],
			    :action_planning_disability_22 => [[:action_planning_disability_5,""]],
			    :action_planning_disability_23 => [[:action_planning_disability_5,""]],
			    :action_planning_disability_24 => [[:action_planning_disability_5,""]],
			    :action_planning_disability_25 => [[:action_planning_disability_5,""]],
			    :action_planning_disability_47 => [[:action_planning_disability_30,""]],
			    :action_planning_disability_48 => [[:action_planning_disability_30,""]],
			    :action_planning_disability_49 => [[:action_planning_disability_30,""]],
			    :action_planning_disability_50 => [[:action_planning_disability_30,""]],
			    :action_planning_sexual_orientation_6 => [[:action_planning_sexual_orientation_1,""]],
			    :action_planning_sexual_orientation_7 => [[:action_planning_sexual_orientation_1,""]],
			    :action_planning_sexual_orientation_8 => [[:action_planning_sexual_orientation_1,""]],
			    :action_planning_sexual_orientation_9 => [[:action_planning_sexual_orientation_1,""]],
			    :action_planning_sexual_orientation_31 => [[:action_planning_sexual_orientation_26,""]],
			    :action_planning_sexual_orientation_32 => [[:action_planning_sexual_orientation_26,""]],
			    :action_planning_sexual_orientation_33 => [[:action_planning_sexual_orientation_26,""]],
			    :action_planning_sexual_orientation_34 => [[:action_planning_sexual_orientation_26,""]],
			    :action_planning_sexual_orientation_10 => [[:action_planning_sexual_orientation_2,""]],
			    :action_planning_sexual_orientation_11 => [[:action_planning_sexual_orientation_2,""]],
			    :action_planning_sexual_orientation_12 => [[:action_planning_sexual_orientation_2,""]],
			    :action_planning_sexual_orientation_13 => [[:action_planning_sexual_orientation_2,""]],
			    :action_planning_sexual_orientation_35 => [[:action_planning_sexual_orientation_27,""]],
			    :action_planning_sexual_orientation_36 => [[:action_planning_sexual_orientation_27,""]],
			    :action_planning_sexual_orientation_37 => [[:action_planning_sexual_orientation_27,""]],
			    :action_planning_sexual_orientation_38 => [[:action_planning_sexual_orientation_27,""]],
			    :action_planning_sexual_orientation_14 => [[:action_planning_sexual_orientation_3,""]],
			    :action_planning_sexual_orientation_15 => [[:action_planning_sexual_orientation_3,""]],
			    :action_planning_sexual_orientation_16 => [[:action_planning_sexual_orientation_3,""]],
			    :action_planning_sexual_orientation_17 => [[:action_planning_sexual_orientation_3,""]],
			    :action_planning_sexual_orientation_39 => [[:action_planning_sexual_orientation_28,""]],
			    :action_planning_sexual_orientation_40 => [[:action_planning_sexual_orientation_28,""]],
			    :action_planning_sexual_orientation_41 => [[:action_planning_sexual_orientation_28,""]],
			    :action_planning_sexual_orientation_42 => [[:action_planning_sexual_orientation_28,""]],
			    :action_planning_sexual_orientation_18 => [[:action_planning_sexual_orientation_4,""]],
			    :action_planning_sexual_orientation_19 => [[:action_planning_sexual_orientation_4,""]],
			    :action_planning_sexual_orientation_20 => [[:action_planning_sexual_orientation_4,""]],
			    :action_planning_sexual_orientation_21 => [[:action_planning_sexual_orientation_4,""]],
			    :action_planning_sexual_orientation_43 => [[:action_planning_sexual_orientation_29,""]],
			    :action_planning_sexual_orientation_44 => [[:action_planning_sexual_orientation_29,""]],
			    :action_planning_sexual_orientation_45 => [[:action_planning_sexual_orientation_29,""]],
			    :action_planning_sexual_orientation_46 => [[:action_planning_sexual_orientation_29,""]],
			    :action_planning_sexual_orientation_22 => [[:action_planning_sexual_orientation_5,""]],
			    :action_planning_sexual_orientation_23 => [[:action_planning_sexual_orientation_5,""]],
			    :action_planning_sexual_orientation_24 => [[:action_planning_sexual_orientation_5,""]],
			    :action_planning_sexual_orientation_25 => [[:action_planning_sexual_orientation_5,""]],
			    :action_planning_sexual_orientation_47 => [[:action_planning_sexual_orientation_30,""]],
			    :action_planning_sexual_orientation_48 => [[:action_planning_sexual_orientation_30,""]],
			    :action_planning_sexual_orientation_49 => [[:action_planning_sexual_orientation_30,""]],
			    :action_planning_sexual_orientation_50 => [[:action_planning_sexual_orientation_30,""]],
			    :action_planning_faith_6 => [[:action_planning_faith_1,""]],
			    :action_planning_faith_7 => [[:action_planning_faith_1,""]],
			    :action_planning_faith_8 => [[:action_planning_faith_1,""]],
			    :action_planning_faith_9 => [[:action_planning_faith_1,""]],
			    :action_planning_faith_31 => [[:action_planning_faith_26,""]],
			    :action_planning_faith_32 => [[:action_planning_faith_26,""]],
			    :action_planning_faith_33 => [[:action_planning_faith_26,""]],
			    :action_planning_faith_34 => [[:action_planning_faith_26,""]],
			    :action_planning_faith_10 => [[:action_planning_faith_2,""]],
			    :action_planning_faith_11 => [[:action_planning_faith_2,""]],
			    :action_planning_faith_12 => [[:action_planning_faith_2,""]],
			    :action_planning_faith_13 => [[:action_planning_faith_2,""]],
			    :action_planning_faith_35 => [[:action_planning_faith_27,""]],
			    :action_planning_faith_36 => [[:action_planning_faith_27,""]],
			    :action_planning_faith_37 => [[:action_planning_faith_27,""]],
			    :action_planning_faith_38 => [[:action_planning_faith_27,""]],
			    :action_planning_faith_14 => [[:action_planning_faith_3,""]],
			    :action_planning_faith_15 => [[:action_planning_faith_3,""]],
			    :action_planning_faith_16 => [[:action_planning_faith_3,""]],
			    :action_planning_faith_17 => [[:action_planning_faith_3,""]],
			    :action_planning_faith_39 => [[:action_planning_faith_28,""]],
			    :action_planning_faith_40 => [[:action_planning_faith_28,""]],
			    :action_planning_faith_41 => [[:action_planning_faith_28,""]],
			    :action_planning_faith_42 => [[:action_planning_faith_28,""]],
			    :action_planning_faith_18 => [[:action_planning_faith_4,""]],
			    :action_planning_faith_19 => [[:action_planning_faith_4,""]],
			    :action_planning_faith_20 => [[:action_planning_faith_4,""]],
			    :action_planning_faith_21 => [[:action_planning_faith_4,""]],
			    :action_planning_faith_43 => [[:action_planning_faith_29,""]],
			    :action_planning_faith_44 => [[:action_planning_faith_29,""]],
			    :action_planning_faith_45 => [[:action_planning_faith_29,""]],
			    :action_planning_faith_46 => [[:action_planning_faith_29,""]],
			    :action_planning_faith_22 => [[:action_planning_faith_5,""]],
			    :action_planning_faith_23 => [[:action_planning_faith_5,""]],
			    :action_planning_faith_24 => [[:action_planning_faith_5,""]],
			    :action_planning_faith_25 => [[:action_planning_faith_5,""]],
			    :action_planning_faith_47 => [[:action_planning_faith_30,""]],
			    :action_planning_faith_48 => [[:action_planning_faith_30,""]],
			    :action_planning_faith_49 => [[:action_planning_faith_30,""]],
			    :action_planning_faith_50 => [[:action_planning_faith_30,""]]
                            }
    dependency = @dependent_questions[question]
    if dependency then
      response = send(question)
      dependant_correct = true
      dependency.each do
	      |dependent|
	      if dependent[1].class == String then
		   dependant_correct = dependant_correct && !(send(dependent[0]).to_s.length > 0)   
	      else
		dependant_correct = dependant_correct && !(send(dependent[0])==dependent[1])
	      end
	end
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