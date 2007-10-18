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
  has_many :issues, :dependent => :destroy
  
# 
#27-Stars Joe: percentage_answered allows you to find the percentage answered of a group of questions. 
#
  def percentage_answered(section = nil, strand = nil)
    sec_questions = []
    number_answered = 0
    total = 0
    Function.get_question_names(section, strand).each{|question| if check_question(question) then number_answered += 1; total += 1 else total += 1 end}
    issues = Issue.find(:all, :conditions => {:strand => strand, :function_id => self.id}) unless strand
    issues = Issue.find(:all, :conditions => {:function_id => self.id}) unless issues
    issue_names = []
    Issue.content_columns.each{|column| issue_names.push(column.name)}
    unless section or !(section == :action_planning) then
	issues.each do |issue|
		issue_names.each do |name| 
			if check_response(issue.send(name)) then
				total += 1
				number_answered += 1
			else 
				total += 1
			end
		end
	end
    end
    return ((Float(number_answered)/total)*100).round unless total == 0
    return 0
  end
  
  def started(section = nil, strand = nil)  
    (percentage_answered(section, strand) > 0)
  end
  
  def completed(section = nil, strand = nil)
    (percentage_answered(section, strand) == 100)    
  end
  
  def statistics
    return nil unless completed # Don't calculate stats if all the necessary questions haven't been answered
    questions = {}
    question_hash = question_wording_lookup
    question_hash.each do |strand_name, strand|
	strand.each do |section_name, section|
		section.each_key do |question|
			questions[strand_name] = {"#{section_name.to_s}_#{topic.to_s}_#{question.to_s}".to_sym => send("#{section_name.to_s}_#{topic.to_s}_#{question.to_s}".to_sym)}
		end
	end
    end
    test = Statistics.new(question_hash)
    test.score(questions, self)
    test.function
  end

#This method recovers questions. It allows you to search by strand or by section.
  def self.get_question_names(section = nil, strand = nil, number = nil)
	  questions = []
	  unnecessary_columns = [:name, :approved, :created_on, :updated_on, :updated_by, :deleted_on]
	  Function.content_columns.each{|column| questions.push(column.name.to_sym)}
	  unnecessary_columns.each{|column| questions.delete(column)}
	  questions.delete_if{ |question| !(question.to_s.include?(section.to_s))}if section
	  questions.delete_if{ |question| !(question.to_s.include?(strand.to_s))}if strand
	  questions.delete_if{ |question| !(question.to_s.include?(number.to_s))} if number
	  return questions
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
  def question_wording_lookup(section = nil, strand = nil, question = nil)
	 fun_flag = false
	 if fun_flag then
		fun_pol_indicator = "Function"
	else
		fun_pol_indicator = "Policy"
	end
	existing_proposed = "proposed"
	case existing_proposed
		when "existing"
			part_need = "the particular needs of "
			wordings = {:gender =>  "men and women",
				:race => "individuals from different ethnic backgrounds",
				:disability => "individuals with different kinds of disability",
				:faith => "individuals of different faiths",
				:sexual_orientation => "individuals of different sexual orientations",
				:age => "individuals of different ages",
				:overall => "" #This line is needed, so that when the hash is evaluated it doesn't throw an error. It will never be displayed though.
			}
			strands = {:gender =>  "Gender",
				:race => "Race",
				:disability => "Disability",
				:faith => "Faith",
				:sexual_orientation => "Lesbian Gay Bisexual and Transgender",
				:age => "Age"
			}
			unless strand then
				question_hash = {}
				strands.each_key{|strand| question_hash[strand] = question_wording_lookup(section, strand, question)}
				return question_hash
			end
			questions = {
				:purpose =>{
					3  => ["If the #{fun_pol_indicator} was performed well does it affect #{wordings[strand]} differently?", :impact_level],
					4  => ["If the #{fun_pol_indicator} was performed badly does it affect #{wordings[strand]} differently?", :impact_level]
				},
				:performance => {
					1 => ["How would you rate the current performance of the #{fun_pol_indicator} in meeting #{part_need + wordings[strand]}?", :rating],
					2 => ["Has this performance assessment been confirmed?", :yes_no_notsure],
					3 => ["Please note the process by which the performance was confirmed", :string],
					4 => ["Are there any performance issues which might have implications for #{wordings[strand]}?", :yes_no_notsure],
					5 => ["Please record any such performance issues for #{wordings[strand]}?", :text]
				},
				:confidence_information => {
					1 => ["Are there any gaps in the information about the #{fun_pol_indicator} in relation to #{wordings[strand]}?", :yes_no_notsure],
					2 => ["Are there plans to collect additional information?", :yes_no_notsure],
					3 => ["If there are plans to collect more information what are the timescales?", :timescales],
					4 => ["Are there any other ways by which performance in meeting the #{part_need + wordings[strand]} could be assessed?", :yes_no_notsure],
					5 => ["Please record any such performance measures for #{wordings[strand]}", :text]
				},
				:confidence_consultation => {
					1 => ["Have groups from the #{strands[strand]} Equality Strand been consulted on the potential impact of the #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure],
					2 => ["If no, why is this so?", :consult_groups],
					3 => ["If yes, list groups and dates.", :text],
					4 => ["Have experts from the #{strands[strand]} Equality Strand been consulted on the potential impact of the #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure],
					5 => ["If no, why is this so?",  :consult_experts],
					6 => ["If yes, list groups and dates.", :text],
					7 => ["Did the consultations identify any isues with the impact of the function on #{wordings[strand]}?", :yes_no_notsure],
					8 => ['Please record the issues identified:', :text]
				},
				:additional_work =>{ 
					5 => ["In the light of the information recorded above are there any areas where you feel that you need more information to obtain a comprehensive view of how 
						the #{fun_pol_indicator} impacts, or may impact, upon #{wordings[strand]}?", :yes_no_notsure],
					6 => ["Please explain the further information required.", :text],
					7 => ["Is there any more work you feel is necessary to complete the assessment?", :yes_no_notsure],
					8 => ["Do you think that the #{fun_pol_indicator} could have a role in preventing #{wordings[strand]} being treated differently, in an unfair way, just because they were #{wordings[strand]}", :text],
					9 => ["Do you think that the #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were not subject to 
					   inappropriate treatment as a result of their #{strand.to_s.gsub("_"," ")}?", :yes_no_notsure],
					10 => ["Do you think that the #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were treated equally and fairly?", :yes_no_notsure],
					11 => ["Do you think that the #{fun_pol_indicator} could assist #{wordings[strand]} to get on better with each other?", :yes_no_notsure],
					12 => ["Do you think that the #{fun_pol_indicator} takes account of #{strand.to_s.capitalize} even if it means treating #{wordings[strand]} more favourably?", :yes_no_notsure],
					13 => ["Do you think that the #{fun_pol_indicator} could assist #{wordings[strand]} to participate more?", :yes_no_notsure],
					14 => ["Do you think that the #{fun_pol_indicator} could assist in promoting positive attitudes to #{wordings[strand]}?", :yes_no_notsure]
				}
			}
			overall_questions = {
				:purpose =>{
					#add existence_status in here?
					2 => ["What is the target outcome of the Function", :text],
					5 =>['Service users', :impact_amount],
					6 =>['Staff employed by the council', :impact_amount],
					7 =>['Staff of supplier organisations', :impact_amount],
					8 =>['Staff of partner organisations', :impact_amount],
					9 =>['Employees of businesses', :impact_amount]
				},
				:performance => { 
					1 =>['How would you rate the current performance of the Function?', :rating], 
					2 =>['Has this performance been validated?', :yes_no_notsure],
					3 =>['Please note the validation regime:', :string],
					4 =>['Are there any performance issues which might have implications for different individuals within the equality group?', :yes_no_notsure],
					5 =>['Please note any such performance issues:', :text]
				},
				:confidence_information => {
					1 => ['Are there any gaps in the information about the Function?', :yes_no_notsure],
					2 => ['Are there plans to collect additional information?', :yes_no_notsure],
					3 => ['If there are plans to collect more information, what are the timescales?', :timescales],
					4 => ['Are there any others ways by which performance could be assessed?', :yes_no_notsure],
					5 => ['Please note any other performance measures:', :text]
				}
			}
			unless section then return questions end
			if strand && section&&!(question) then return questions[section]end
			unless strand == :overall then
				return questions[section][question]
			else
				return overall_questions[section][question]
			end
		when "proposed"
			part_need = "the particular needs of "
			wordings = {:gender =>  "men and women",
				:race => "individuals from different ethnic backgrounds",
				:disability => "individuals with different kinds of disability",
				:faith => "individuals of different faiths",
				:sexual_orientation => "individuals of different sexual orientations",
				:age => "individuals of different ages",
				:overall => "" #This line is needed, so that when the hash is evaluated it doesn't throw an error. It will never be displayed though.
			}
			strands = {:gender =>  "Gender",
				:race => "Race",
				:disability => "Disability",
				:faith => "Faith",
				:sexual_orientation => "Lesbian Gay Bisexual and Transgender",
				:age => "Age"
			}
			unless strand then
				question_hash = {}
				strands.each_key{|strand| question_hash[strand] = question_wording_lookup(section, strand, question)}
				return question_hash
			end
			questions = {
				:purpose =>{
					3  => ["If the #{fun_pol_indicator} is performed well will it affect #{wordings[strand]} differently?", :impact_level],
					4  => ["If the #{fun_pol_indicator} is performed badly will it affect #{wordings[strand]} differently?", :impact_level]
				},
				:performance => {
					1 => ["How would you assess the potential performance of the #{fun_pol_indicator} in meeting #{part_need + wordings[strand]}?", :rating],
					2 => ["Has this performance assessment been confirmed?", :yes_no_notsure],
					3 => ["Please note the process by which the performance is confirmed", :string],
					4 => ["Are there likely to be any performance issues which might have implications for #{wordings[strand]}?", :yes_no_notsure],
					5 => ["Please record any such performance issues for #{wordings[strand]}?", :text]
				},
				:confidence_information => {
					1 => ["Will information about the #{fun_pol_indicator} be collected to determine the impact on #{wordings[strand]}?", :yes_no_notsure],
					2 => ["Are there plans to collect additional information?", :yes_no_notsure],
					3 => ["If there are plans to collect more information what are the timescales?", :timescales],
					4 => ["Are there any other ways by which the impact of the #{fun_pol_indicator} on #{wordings[strand]} could be assessed?", :yes_no_notsure],
					5 => ["Please record any such impact measures for #{wordings[strand]}", :text]
				},
				:confidence_consultation => {
					1 => ["Have groups from the #{strands[strand]} Equality Strand been consulted on the potential impact of the proposed #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure],
					2 => ["If no, why is this so?", :consult_groups],
					3 => ["If yes, list groups and dates.", :text],
					4 => ["Have experts from the #{strands[strand]} Equality Strand been consulted on the potential impact of the proposed #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure],
					5 => ["If no, why is this so?",  :consult_experts],
					6 => ["If yes, list groups and dates.", :text],
					7 => ["Did the consultations identify any isues with the impact of the function on #{wordings[strand]}?", :yes_no_notsure],
					8 => ['Please record the issues identified:', :text]
				},
				:additional_work =>{ 
					5 => ["In the light of the information recorded above are there any areas where you feel that you need more information to obtain a comprehensive view of how 
						the proposed #{fun_pol_indicator} may impact upon #{wordings[strand]}?", :yes_no_notsure],
					6 => ["Please explain the further information required.", :text],
					7 => ["Is there any more work you feel is necessary to complete the assessment?", :yes_no_notsure],
					8 => ["Do you think that the proposed #{fun_pol_indicator} could have a role in preventing #{wordings[strand]} being treated differently, in an unfair way, just because they were #{wordings[strand]}", :text],
					9 => ["Do you think that the proposed #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were not subject to 
					   inappropriate treatment as a result of their #{strand.to_s.gsub("_"," ")}?", :yes_no_notsure],
					10 => ["Do you think that the proposed #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were treated equally and fairly?", :yes_no_notsure],
					11 => ["Do you think that the proposed #{fun_pol_indicator} could assist #{wordings[strand]} to get on better with each other?", :yes_no_notsure],
					12 => ["Do you think that the proposed #{fun_pol_indicator} takes account of #{strand.to_s.capitalize} even if it means treating #{wordings[strand]} more favourably?", :yes_no_notsure],
					13 => ["Do you think that the proposed #{fun_pol_indicator} could assist #{wordings[strand]} to participate more?", :yes_no_notsure],
					14 => ["Do you think that the proposed#{fun_pol_indicator} could assist in promoting positive attitudes to #{wordings[strand]}?", :yes_no_notsure]
				}
			}
			overall_questions = {
				:purpose =>{
					#add existence_status in here?
					2 => ["What is the target outcome of the Function", :text],
					5 =>['Service users', :impact_amount],
					6 =>['Staff employed by the council', :impact_amount],
					7 =>['Staff of supplier organisations', :impact_amount],
					8 =>['Staff of partner organisations', :impact_amount],
					9 =>['Employees of businesses', :impact_amount]
				},
				:performance => { 
					1 =>['How would you rate the current performance of the Function?', :rating], 
					2 =>['Has this performance been validated?', :yes_no_notsure],
					3 =>['Please note the validation regime:', :string],
					4 =>['Are there any performance issues which might have implications for different individuals within the equality group?', :yes_no_notsure],
					5 =>['Please note any such performance issues:', :text]
				},
				:confidence_information => {
					1 => ['Are there any gaps in the information about the Function?', :yes_no_notsure],
					2 => ['Are there plans to collect additional information?', :yes_no_notsure],
					3 => ['If there are plans to collect more information, what are the timescales?', :timescales],
					4 => ['Are there any others ways by which performance could be assessed?', :yes_no_notsure],
					5 => ['Please note any other performance measures:', :text]
				}
			}
			unless section then return questions end
			if strand && section&&!(question) then return questions[section]end
			unless strand == :overall then
				return questions[section][question]
			else
				return overall_questions[section][question]
			end
	end
end

private
#
#27 stars Joe: Removed specific section code, turned it into a generic section format.
#Must go back and comment code. 

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