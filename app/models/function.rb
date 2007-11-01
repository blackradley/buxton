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
  
  
  def strategy(strategy)
    Strategy.find(strategy)
  end
# 
#27-Stars Joe: percentage_answered allows you to find the percentage answered of a group of questions. 
#
  def percentage_answered(section = nil, strand = nil)
    sec_questions = []
    issue_strand = []
    number_answered = 0
    total = 0
    #Check whether each question is completed. If it is, add one to the amount that are completed. In both cases, add one to the total. 
    #TODO: DRY? {|question| if check_question(question) then number_answered += 1 end; total += 1} might be better?
    Function.get_question_names(section, strand).each{|question| if check_question(question) then number_answered += 1; total += 1 else total += 1 end} 
    #If you don't specify a section, or your section is action planning, consider issues as well.
    unless section && !(section == :action_planning) then 
        issue_strand = self.issues.clone
        issue_strand.delete_if{|issue_name| issue_name.strand != strand.to_s} if strand
        issue_names = []
        Issue.content_columns.each{|column| issue_names.push(column.name)}
        issue_names.delete('strand')
	issue_strand.each do |issue_name|
		issue_names.each do |name|
			if check_response(issue_name.send(name.to_sym)) then
				total += 1
				number_answered += 1
			else 
				total += 1
			end
		end
	end
     end
    #If you don't suggest a section, or your section is purpose, then consider strategies as well.
    unless section && !(section == :purpose) then
	function_strategies.each do |strategy| 
		if check_response(strategy.strategy_response) then
			total += 1
			number_answered += 1
		else 
			total += 1
		end
	end
    end
    return ((Float(number_answered)/total)*100).round unless total == 0  #Calculate percentage as long as there are questions.
    return 100  #If there are no questions in a section, return complete for it. TODO: See if Iain wants this behavior.
  end
  
   #The started tag allows you to check whether a function, section, or strand has been started. This is basically works by running check_percentage, but as 
   #soon as it finds a true value, it breaks out of the loop and returns false. If you request a function started from it, it checks whether the 2 questions
   #that you have to answer(function/policy and proposed/overall) have been answered or not, and if they have not been answered, then no others can be
   # and if they have, then the function is by definition started
  def started(section = nil, strand = nil)  
    return (check_question(:purpose_overall_1) && check_question(:function_policy)) unless (section or strand)
    started = false
    Function.get_question_names(section, strand).each{|question| if check_question(question) then started = true; break; end}
    unless started then #If the function has already been found to be started, then there isn't any need to check further
	unless section && !(section == :action_planning) then #This checks whether all the issues have been completed.
	     issue_strand = self.issues.clone
	     issue_strand.delete_if{|issue_name| issue_name.strand != strand.to_s} if strand
	     issue_names = []
	     Issue.content_columns.each{|column| issue_names.push(column.name)}
	     issue_names.delete('strand')
	     issue_strand.each do |issue_name|
		issue_names.each do |name|
			break if started
			if check_response(issue_name.send(name.to_sym)) then
				started  = true
				break
			end
		end
	    end
        end
	unless section && !(section == :purpose) then #Check strategies are completed.
		function_strategies.each do |strategy| 
			if check_response(strategy.strategy_response) then
				started = true
				break
			end
		end
	end      
    end
    return started
  end
  
  #This allows you to check whether a function, section or strand has been completed. It runs like started, but only breaking when it finds a question
  #that has not been answered. Hence, it is at its slowest where there is a single unanswered question in each section. In worst case it has to run 
  #through every question bar n where n is the number of functions, making it a O(n) algorithm.
  #TODO: Is it possible to optimise it by setting it to flick back and forth between the end and the start, on the assumption that people
  #will answer it logically, meaning that if they fail to answer a question, it is more likely to be either at the end or start than the middle. Such a
  #change would make no difference to the runtime in the worst case, and could well speed it up in best case.
  def completed(section = nil, strand = nil)
    completed = true
    Function.get_question_names(section, strand).each{|question| unless check_question(question) then completed = false; break; end}
    if completed then
	unless section && !(section == :action_planning) then
	     issue_strand = self.issues.clone
	     issue_strand.delete_if{|issue_name| issue_name.strand != strand.to_s} if strand
	     issue_names = []
	     Issue.content_columns.each{|column| issue_names.push(column.name)}
	     issue_names.delete('strand')
	     issue_strand.each do |issue_name|
		issue_names.each do |name|
			break unless completed
			unless check_response(issue_name.send(name.to_sym)) then
				completed = false
				break
			end
		end
	    end
        end
	unless section && !(section == :purpose) then
		function_strategies.each do |strategy| 
			unless check_response(strategy.strategy_response) then
				completed = false
				break
			end
		end
	end      
    end
    return completed
  end
  
  #This initilises a statistics object, and scores it.
  #TODO: Heavy amount of speed increases. No extensive comments as yet, because I'm anticipating ripping this
  #calling method out and replacing it with a much faster version. Statistics library should remain largly unchanged though.
  def statistics
    return nil unless completed # Don't calculate stats if all the necessary questions haven't been answered
    questions = {}
    question_hash = question_wording_lookup
    question_hash.each do |strand_name, strand|
	strand.each do |section_name, section|
		section.each_key do |question|
			question_name = "#{section_name.to_s}_#{strand_name.to_s}_#{question.to_s}".to_sym
			begin
				dependency = dependent_questions(question_name)
				if dependency then
				      dependant_correct = true
				      dependency.each do
					      |dependent|
					      if dependent[1].class == String then
						   dependant_correct = dependant_correct && !(send(dependent[0]).to_s.length > 0)   
					      else
						dependant_correct = dependant_correct && !(send(dependent[0])==dependent[1])
					      end
					end
				      questions[question_name] = send(question_name) if dependant_correct
				else
					questions[question_name] = send(question_name)
				end
			rescue
			end
		end
	end
    end
    test = Statistics.new(question_wording_lookup, self)
    test.score(questions)
    test.function
  end

#This method recovers questions. It allows you to search by strand or by section.
#It works by getting a list of all the columns, then removing any ones which aren't quesitons. 
#NOTE: Should a new column be added to function that isn't a question, it should also be added here.
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
  
  #^^ Are those really required any more?
  
  #This function returns the wording of a particular question. It takes a section strand and question number as arguments, and returns that specific question.
  #It can also be passed nils, and in that event, it will automatically return an array containing all the values that corresponded to the nils. Hence, to return all
  #questions and their lookup types, just func.question_wording_lookup suffices.
  def question_wording_lookup(section = nil, strand = nil, question = nil)
	begin 
	fun_pol_indicator = LookUp.function_policy.find{|lookUp| self.function_policy == lookUp.value}.name.downcase #Detect whether it is a function or a policy
	existing_proposed = LookUp.existing_proposed.find{|lookUp| self.purpose_overall_1 == lookUp.value}.name.downcase #Detect whether it is an existing function or a proposed function.
	rescue
	end
	if (purpose_overall_1 == 0 || purpose_overall_1 == nil) then existing_proposed = "proposed" end
	if function_policy == 0 then fun_pol_indicator = "------" end
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
				:age => "Age",
				:overall => "Overall" #Again, this is inserted to ensure that when you check all strands you return every question. It should never be displayed.
			}
			#For every strand in the strands array, loop through them and call question_wording_lookup on each of them if strand is nil. This ensures the result is sorted by strand, meaning
			#that the statistics are very much simpler.
			unless strand then
				question_hash = {}
				strands.each_key{|strand| question_hash[strand] = question_wording_lookup(section, strand, question)} 
				return question_hash
			end
			#Simply a hash to define existing questions and their lookup types.
			questions = {
				:purpose =>{
					3  => ["If the #{fun_pol_indicator} was performed well does it affect #{wordings[strand]} differently?", :impact_level],
					4  => ["If the #{fun_pol_indicator} was performed badly does it affect #{wordings[strand]} differently?", :impact_level]
				},
				:performance => {
					1 => ["How would you rate the current performance of the #{fun_pol_indicator} in meeting #{part_need + wordings[strand]}?", :rating],
					2 => ["Has this performance assessment been confirmed?", :yes_no_notsure_n5_0],
					3 => ["Please note the process by which the performance was confirmed", :string],
					4 => ["Are there any performance issues which might have implications for #{wordings[strand]}?", :yes_no_notsure_10_0],
					5 => ["Please record any such performance issues for #{wordings[strand]}?", :text]
				},
				:confidence_information => {
					1 => ["Are there any gaps in the information about the #{fun_pol_indicator} in relation to #{wordings[strand]}?", :yes_no_notsure_15_0],
					2 => ["Are there plans to collect additional information?", :yes_no_notsure_n5_0],
					3 => ["If there are plans to collect more information what are the timescales?", :timescales],
					4 => ["Are there any other ways by which performance in meeting the #{part_need + wordings[strand]} could be assessed?", :yes_no_notsure_n3_0],
					5 => ["Please record any such performance measures for #{wordings[strand]}", :text]
				},
				:confidence_consultation => {
					1 => ["Have groups from the #{strands[strand]} Equality Strand been consulted on the potential impact of the #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure_3_10],
					2 => ["If no, why is this so?", :consult_groups],
					3 => ["If yes, list groups and dates.", :text],
					4 => ["Have experts from the #{strands[strand]} Equality Strand been consulted on the potential impact of the #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure_2_5],
					5 => ["If no, why is this so?",  :consult_experts],
					6 => ["If yes, list groups and dates.", :text],
					7 => ["Did the consultations identify any issues with the impact of the function on #{wordings[strand]}?", :yes_no_notsure_3_0],
				},
				:additional_work =>{ 
					5 => ["In the light of the information recorded above are there any areas where you feel that you need more information to obtain a comprehensive view of how 
						the #{fun_pol_indicator} impacts, or may impact, upon #{wordings[strand]}?", :yes_no_notsure],
					6 => ["Please explain the further information required.", :text],
					7 => ["Is there any more work you feel is necessary to complete the assessment?", :yes_no_notsure],
					8 => ["Do you think that the #{fun_pol_indicator} could have a role in preventing #{wordings[strand]} being treated differently, in an unfair way, just because they were #{wordings[strand]}", :text],
					9 => ["Do you think that the #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were not subject to inappropriate treatment as a result of their #{strand.to_s.gsub("_"," ")}?", :yes_no_notsure],
					10 => ["Do you think that the #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were treated equally and fairly?", :yes_no_notsure],
					11 => ["Do you think that the #{fun_pol_indicator} could assist #{wordings[strand]} to get on better with each other?", :yes_no_notsure],
					12 => ["Do you think that the #{fun_pol_indicator} takes account of #{strand.to_s.capitalize} even if it means treating #{wordings[strand]} more favourably?", :yes_no_notsure],
					13 => ["Do you think that the #{fun_pol_indicator} could assist #{wordings[strand]} to participate more?", :yes_no_notsure],
					14 => ["Do you think that the #{fun_pol_indicator} could assist in promoting positive attitudes to #{wordings[strand]}?", :yes_no_notsure]
				}
			}
			overall_questions = {
				:purpose =>{
					1 => ["What is the existence status of the #{fun_pol_indicator}?", :existing_proposed], #This should never be displayed, but it never hurts to be sure and put some meaningful text it. It is there for the stats.
					2 => ["What is the target outcome of the #{fun_pol_indicator}", :text],
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
				:age => "Age",
				:overall => "Overall"
			}
			unless strand then
				question_hash = {}
				strands.each_key{|strand| question_hash[strand] = question_wording_lookup(section, strand, question)}
				return question_hash
			end
			questions = {
				:purpose =>{
					3  => ["Would it affect <strong>#{wordings[strand]}</strong> differently?", :impact_level],
					4  => ["Would it affect <strong>#{wordings[strand]}</strong> differently?", :impact_level]
				},
				:performance => {
					1 => ["How would you assess the potential performance of the #{fun_pol_indicator} in meeting #{part_need + wordings[strand]}?", :rating],
					2 => ["Has this performance assessment been confirmed?", :yes_no_notsure_n5_0],
					3 => ["Please note the process by which the performance is confirmed", :string],
					4 => ["Are there likely to be any performance issues which might have implications for #{wordings[strand]}?", :yes_no_notsure],
					5 => ["Please record any such performance issues for #{wordings[strand]}?", :text]
				},
				:confidence_information => {
					1 => ["Will information about the #{fun_pol_indicator} be collected to determine the impact on #{wordings[strand]}?", :yes_no_notsure_15_0],
					2 => ["Are there plans to collect additional information?", :yes_no_notsure_n5_0],
					3 => ["If there are plans to collect more information what are the timescales?", :timescales],
					4 => ["Are there any other ways by which the impact of the #{fun_pol_indicator} on #{wordings[strand]} could be assessed?", :yes_no_notsure_n3_0],
					5 => ["Please record any such impact measures for #{wordings[strand]}", :text]
				},
				:confidence_consultation => {
					1 => ["Have groups from the #{strands[strand]} Equality Strand been consulted on the potential impact of the proposed #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure_3_10],
					2 => ["If no, why is this so?", :consult_groups],
					3 => ["If yes, list groups and dates.", :text],
					4 => ["Have experts from the #{strands[strand]} Equality Strand been consulted on the potential impact of the proposed #{fun_pol_indicator} on #{wordings[strand]}?", :yes_no_notsure_2_5],
					5 => ["If no, why is this so?",  :consult_experts],
					6 => ["If yes, list groups and dates.", :text],
					7 => ["Did the consultations identify any isues with the impact of the function on #{wordings[strand]}?", :yes_no_notsure_3_0],
				},
				:additional_work =>{ 
					5 => ["In the light of the information recorded above are there any areas where you feel that you need more information to obtain a comprehensive view of how 
						the  #{fun_pol_indicator} may impact upon #{wordings[strand]}?", :yes_no_notsure],
					6 => ["Please explain the further information required.", :text],
					7 => ["Is there any more work you feel is necessary to complete the assessment?", :yes_no_notsure],
					8 => ["Do you think that the #{fun_pol_indicator} could have a role in preventing #{wordings[strand]} being treated differently, in an unfair way, just because they were #{wordings[strand]}", :yes_no_notsure],
					9 => ["Do you think that the #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were not subject to inappropriate treatment as a result of their #{strand.to_s.gsub("_"," ")}?", :yes_no_notsure],
					10 => ["Do you think that the #{fun_pol_indicator} could have a role in making sure that #{wordings[strand]} were treated equally and fairly?", :yes_no_notsure],
					11 => ["Do you think that the #{fun_pol_indicator} could assist #{wordings[strand]} to get on better with each other?", :yes_no_notsure],
					12 => ["Do you think that the #{fun_pol_indicator} takes account of #{strand.to_s.capitalize} even if it means treating #{wordings[strand]} more favourably?", :yes_no_notsure],
					13 => ["Do you think that the #{fun_pol_indicator} could assist #{wordings[strand]} to participate more?", :yes_no_notsure],
					14 => ["Do you think that the #{fun_pol_indicator} could assist in promoting positive attitudes to #{wordings[strand]}?", :yes_no_notsure]
				}
			}
			overall_questions = {
				:purpose =>{
					1 => ["What is the existence status of the #{fun_pol_indicator}?", :existing_proposed],#This should never be displayed, but it never hurts to be sure and put some meaningful text it. It is there for the stats.
					2 => ["What is the target outcome of the #{fun_pol_indicator}", :text],
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
	end
	unless strand == :overall then
		return questions unless section
		if strand && section&&!(question) then return questions[section]end
		return questions[section][question]
	else
		return overall_questions unless section
		if strand && section&&!(question) then return overall_questions[section]end		
		return overall_questions[section][question]
	end	
end

private

#Check question takes a single question as an argument and checks if it has been completed, and that any dependent questions have been answered.
  def check_question(question) 
    dependency = dependent_questions(question)
    if dependency then
      response = send(question)
      dependant_correct = true
      dependency.each do #For each dependent question, check that it has the correct value
	      |dependent|
	      if dependent[1].class == String then
		   dependant_correct = dependant_correct && !(send(dependent[0]).to_s.length > 0)   
	      else
		dependant_correct = dependant_correct && !(send(dependent[0])==dependent[1] || send(dependent[0]) == 0)
	      end
	end
      if dependant_correct then #If you don't need to answer this question, automatically give it a completed status
	return true 
      else 
	return (check_response(response)) #Else check it as normal
      end
    else
      response = send(question) #If it has no dependent questions, check it as normal, then return the value.
      return check_response(response)
    end
  end
  
  def check_response(response) #Check response verifies whether a response to a question is correct or not.
    checker = !(response.to_i == 0)
    checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
    return checker
  end
  
#This is the hash of dependent questions, removed to a function for easy maintainability.  
  def dependent_questions(question = nil)
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
			    :confidence_consultation_age_2 => [[:confidence_consultation_age_1, no_value]],
			    :confidence_consultation_age_3 => [[:confidence_consultation_age_1, yes_value]],
			    :confidence_consultation_age_5 => [[:confidence_consultation_age_4, no_value]],
			    :confidence_consultation_age_6 => [[:confidence_consultation_age_4, yes_value]],
			    :confidence_consultation_disability_2 => [[:confidence_consultation_disability_1, no_value]],
			    :confidence_consultation_disability_3 => [[:confidence_consultation_disability_1, yes_value]],
			    :confidence_consultation_disability_5 => [[:confidence_consultation_disability_4, no_value]],
			    :confidence_consultation_disability_6 => [[:confidence_consultation_disability_4, yes_value]],
			    :confidence_consultation_race_2 => [[:confidence_consultation_race_1, no_value]],
			    :confidence_consultation_race_3 => [[:confidence_consultation_race_1, yes_value]],
			    :confidence_consultation_race_5 => [[:confidence_consultation_race_4, no_value]],
			    :confidence_consultation_race_6 => [[:confidence_consultation_race_4, yes_value]],
			    :confidence_consultation_faith_2 => [[:confidence_consultation_faith_1, no_value]],
			    :confidence_consultation_faith_3 => [[:confidence_consultation_faith_1, yes_value]],
			    :confidence_consultation_faith_5 => [[:confidence_consultation_faith_4, no_value]],
			    :confidence_consultation_faith_6 => [[:confidence_consultation_faith_4, yes_value]],
			    :confidence_consultation_sexual_orientation_2 => [[:confidence_consultation_sexual_orientation_1, no_value]],
			    :confidence_consultation_sexual_orientation_3 => [[:confidence_consultation_sexual_orientation_1, yes_value]],
			    :confidence_consultation_sexual_orientation_5 => [[:confidence_consultation_sexual_orientation_4, no_value]],
			    :confidence_consultation_sexual_orientation_6 => [[:confidence_consultation_sexual_orientation_4, yes_value]],
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
	if question then return @dependent_questions[question] else return @dependent_questions end # If you specify a question, return it, else return the entire hash.
  end
end