#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
# Activitys are identifed by their name, which does not have to be unique but
# it might be a good idea since the Organisation manager will use the name
# to identify the activity.
#
# When a activity is created a single User is created for it at the same time,
# who is listed in the user table.  If the same person (as identified by their
# email address) is the activity manager for a number of activitys then they
# are entered many time into the User table.
#
# The activitys are supposed to contribute to organisational goals or
# strategies hence they link to a ActivityStrategy.  This is not a "has many
# and belongs to" where the intervening table would be transparent, because we
# want to store a value in the activity_strategy table of how much of a contribution
# is being made to the strategy.
#
# Neither is a "has many: through" used because like the "has many and belongs to"
# it is not really a many to many relationship. Each Strategy is owned by
# the Organisation, and each Activity then contributes (or doesn't contribute) to
# each of the strategies.  The strategy list for each activity within an organisation
# is always the same, and the response is stored in the activity_strategy table.
#
class Activity < ActiveRecord::Base
  has_one :activity_manager, :dependent => :destroy
  has_one :activity_approver, :dependent => :destroy
  belongs_to :directorate
  # Fake belongs_to :organisation, :through => :directorate
  delegate :organisation, :organisation=, :to => :directorate

  has_many :activity_strategies, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_and_belongs_to_many :projects

  validates_presence_of :name, :message => 'All activities must have a name.'
  validates_presence_of :activity_manager, :activity_approver  
  validates_presence_of :directorate
  validates_associated :activity_manager, :activity_approver
  validates_associated :questions
  # validates_uniqueness_of :name, :scope => :directorate_id

  has_many :questions, :dependent => :destroy

  attr_accessor :activity_clone, :saved
  before_save :set_approved
  before_save :create_questions_if_new

  after_update :save_issues

  def activity_type
    if self.started then
      [self.existing_proposed?, self.function_policy?].join(' ')
    else
      '-'
    end
  end

  def parents
    @@parents
  end

  def header(header_placing)
    fun_pol = self.function_policy.to_i
    fun_pol -= 1
    fun_pol = 0 if fun_pol == -1
    exist_prop = self.existing_proposed.to_i
    exist_prop -= 1
    exist_prop = 0 if exist_prop == -1
    return hashes['headers'][header_placing.to_s][fun_pol][exist_prop]
  end
  def existing_proposed?
    hashes['choices'][8][self.existing_proposed.to_i]
  end

  def fun_pol_number
    fun_pol = self.function_policy.to_i
    fun_pol -= 1
    fun_pol = 0 if fun_pol == -1
    fun_pol
  end

  def exist_prop_number
    exist_prop = self.existing_proposed.to_i
    exist_prop -= 1
    exist_prop = 0 if exist_prop == -1
    exist_prop
  end
  def existing?
   self.existing_proposed == 1
  end

  def proposed?
    self.existing_proposed == 2
  end

  def function?
    self.function_policy == 1
  end

  def policy?
    self.function_policy == 2
  end

  def hashes
    @@Hashes
  end

  def create_questions_if_new
    # Initialise a question, for every question name, if this is a new record
    if self.new_record? and self.questions.empty? then
      Activity.get_question_names.each do |question_name|
        question = self.questions.build(:name => question_name.to_s)
        question.needed = true
      end
    end
  end

  def set_approved
    if self.approved then
      if !self.approved_on then
        self.approved_on = Time.now
      end
    else
      self.approved_on = nil
    end
  end

  def function_policy?
    hashes['choices'][9][self.function_policy.to_i]
  end

  def existing_proposed_name
    hashes['choices'][8][self.existing_proposed.to_i]
  end
  
  def approved?
    self.approved == "approved"
  end

  #27-Stars Joe: percentage_answered allows you to find the percentage answered of a group of questions.
  def percentage_answered(section = nil, strand = nil)
    return 0 unless self.started
    #check purpose is completed for anything except purpose
    if section.to_s != 'purpose' then
      return 0 unless self.completed('purpose')
    end
    percentages = {}
    if section.nil? then
      sections.each do |section|
        percentages[section.to_sym] = self.send("calculate_#{section.to_s}_percentage_answered#{('(' + strand.to_s + ')') unless strand.nil?}".to_sym)
      end
    else
      percentages[section.to_sym] =  self.send("calculate_#{section.to_s}_percentage_answered#{('(' + strand.to_s + ')') unless strand.nil?}".to_sym)
    end  
    overall_total = 0
    if section.nil? then
      percentages.values.each{|total| overall_total += total/percentages.values.size}
    else
      overall_total = percentages[section.to_sym]
    end
    (overall_total*100).to_i
  end
  
  def calculate_purpose_percentage_answered(strand = nil)
    new_strand = strand.nil? ? self.strands(true).push("overall").join("|") : strand
    purpose_answered = self.questions.find(:all, :conditions => "name REGEXP 'purpose\_(#{new_strand})' AND (completed = true AND needed = true)").size
    number_of_unanswered_strategies = self.activity_strategies.find(:all, :conditions => 'strategy_response LIKE 0').size
    number_of_strategies = self.activity_strategies.find(:all).size
    number_of_answered_strategies  = number_of_strategies - number_of_unanswered_strategies
    purpose_total = self.questions.find(:all, :conditions => "name REGEXP 'purpose\_(#{new_strand})' AND (needed = true)").size
    #to_f used to cascade cast to floats  
    (purpose_answered.to_f + number_of_answered_strategies)/(number_of_strategies + purpose_total) 
  end
  
  def calculate_generic_percentage_answered(section = nil, strand = nil)
    new_strand = strand.nil? ? self.strands.push("overall").join("|") : strand
    answered = self.questions.find(:all, :conditions => "name REGEXP '#{strand.to_s}\_(#{new_strand})' AND (completed = true AND needed = true)").size
    total = self.questions.find(:all, :conditions => "name REGEXP '#{strand.to_s}\_(#{new_strand})' AND (needed = true)").size
    strands.each do |enabled_strand|
      next unless enabled_strand.to_s.include? strand.to_s
      if section == 'impact' && self.send("impact_#{enabled_strand}_9") == 1 then
        answered -= 1 if self.issues.find(:all, :conditions => "section REGEXP 'impact' AND strand REGEXP '#{enabled_strand.to_s}'").size == 0
      end
      if section == 'consultation' && self.send("consultation_#{enabled_strand}_7") == 1 then
        answered -= 1 if self.issues.find(:all, :conditions => "section REGEXP 'consultation' AND strand REGEXP '#{enabled_strand.to_s}'").size == 0
      end
    end
    return 1.0 if total == 0    
    (answered.to_f)/(total) #to_f used to cascade cast to floats
  end

  def calculate_impact_percentage_answered(strand = nil)
    calculate_generic_percentage_answered('impact', strand)
  end
  
  def calculate_consultation_percentage_answered(strand = nil)
    calculate_generic_percentage_answered('consultation', strand)
  end
  
  def calculate_additional_work_percentage_answered(strand = nil)
    calculate_generic_percentage_answered('additional_work', strand)
  end
  
  def calculate_action_planning_percentage_answered(strand = nil)
    issue_total = 0
    answered = 0
    unanswered_sections = 0
    sections_total = 0
    strands.each do |enabled_strand|
      next unless enabled_strand.to_s.include? strand.to_s
      impact_answer = self.send("impact_#{enabled_strand}_9")
      unanswered_sections += 1 if impact_answer == 0
      sections_total += 1
      if impact_answer == 1 then
        search_string = "section REGEXP 'impact' AND strand REGEXP '#{enabled_strand.to_s}'"
        answered += self.issues.find(:all, :conditions => search_string).inject(0) do |total, issue|
          issue_total += 1
          total += issue.percentage_answered
        end
      end
      consultation_answer = self.send("consultation_#{enabled_strand}_7")
      unanswered_sections += 1 if consultation_answer == 0
      sections_total += 1
      if consultation_answer == 1 then
        search_string = "section REGEXP 'consultation' AND strand REGEXP '#{enabled_strand.to_s}'"
        answered += self.issues.find(:all, :conditions => search_string).inject(0) do |total, issue|
          issue_total += 1
          total += issue.percentage_answered
        end
      end
    end  
    return 0.0 if sections_total == unanswered_sections
    return 1.0 if issue_total == 0
    (answered.to_f/issue_total)*((sections_total - unanswered_sections.to_f)/sections_total)    
  end

   #The started tag allows you to check whether a activity, section, or strand has been started. This is basically works by running check_percentage, but as
   #soon as it finds a true value, it breaks out of the loop and returns false. If you request a activity started from it, it checks whether the 2 questions
   #that you have to answer(activity/policy and proposed/overall) have been answered or not, and if they have not been answered, then no others can be
   # and if they have, then the activity is by definition started
  def started(section = nil, strand = nil)
    return (self.existing_proposed.to_i*self.function_policy.to_i) != 0 if (section.nil? && strand.nil?)
    like = [section, strand].join('\_')
    # Find all incomplete questions with the given arguments
    answered_questions = self.questions.find(:all, :conditions => "name LIKE '%#{like}%'")
    return true if answered_questions.size > 0
    unless section && !(section == :action_planning) then
       #First we calculate all the questions, in case there is a nil.
        answered_questions = []
        answered_questions += self.questions.find(:all, :conditions => "name LIKE 'consultation_%#{strand}_7'")
        answered_questions += self.questions.find(:all, :conditions => "name LIKE 'impact_%#{strand}_9'")
        return true if answered_questions.size > 0
    end
    unless section && !(section == :purpose) then #Check strategies are completed.
      self.activity_strategies.each do |strategy|
        if check_response(strategy.strategy_response) then
          return true
        end
      end
    end
    return false
  end

  #This allows you to check whether a activity, section or strand has been completed. 
  def completed(section = nil, strand = nil)
    is_purpose = (section.to_s == 'purpose')
    #are all the strategies completed if they need to be?
    strategies_not_completed = self.activity_strategies.find(:all, :conditions => 'strategy_response LIKE 0').size > 0
    return false if strategies_not_completed && (is_purpose || section.nil?)
    #Special check for the unique conditions where section and strand are nil
    if section.nil? && strand.nil? then
      search_conditions = "name REGEXP 'purpose' AND completed = false AND needed = true"
      return false if self.questions.find(:all, :conditions => search_conditions).size > 0
    end
    #Are there any questions which are required and not completed?
    new_section = section.nil? ? self.sections.map(&:to_s).join("|") : section
    new_strand = strand.nil? ? self.strands(is_purpose).push("overall").join("|") : strand
    search_conditions = "name REGEXP '(#{new_section})\_(#{new_strand})' AND completed = false AND needed = true"
    return false if self.questions.find(:all, :conditions => search_conditions).size > 0
    #check if we need to check issues?
    issues_to_check = []
    strands(!strand.to_s.blank?).each do |enabled_strand|
      next unless enabled_strand.to_s.include? strand.to_s
      impact_qn = "impact_#{enabled_strand}_9"
      consultation_qn = "consultation_#{enabled_strand}_7"
      impact_answer = self.send(impact_qn.to_sym).to_i
      consultation_answer = self.send(consultation_qn.to_sym).to_i
      impact_needed = (section.to_s == 'impact' || section.to_s == 'action_planning' || section.nil?)
      consultation_needed = (section.to_s == 'consultation' || section.to_s == 'action_planning'  || section.nil?)
      return false if impact_answer == 0 && impact_needed
      return false if consultation_answer == 0 && consultation_needed
      if impact_answer == 1  && impact_needed then
        issues = self.issues_by('impact', enabled_strand)
        return false if issues.size == 0
        issues_to_check << issues
      end
      if consultation_answer == 1 && consultation_needed then
        issues = self.issues_by('consultation', enabled_strand)
        return false if issues.size == 0
        issues_to_check << issues
      end      
    end
    #check the issues are correct from their presence earlier
    issues_to_check.flatten.each{|issue| return false unless issue.check_responses} if (section.nil? || section.to_s == 'action_planning')
    return true
  end

  def target_and_strategies_completed
    answered_questions = self.questions.find(:all, :conditions => "name REGEXP 'purpose\_overall\_[2,11,12]' AND (completed = true OR needed = false)")
    return false unless answered_questions.size == 3
    self.activity_strategies.each do |strategy|
      unless check_response(strategy.strategy_response) then
        return false
      end
    end
    return true
  end

  def impact_on_individuals_completed
    answered_questions = self.questions.find(:all, :conditions => "name REGEXP 'purpose\_overall\_[5,6,7,8,9]' AND (completed = true OR needed = false)")
    return false unless answered_questions.size == 5
    return true
  end

  def impact_on_equality_groups
    answered_questions = []
    self.strands(true).each do |strand|
      answered_questions += self.questions.find(:all, :conditions => "name REGEXP 'purpose\_#{strand.to_s}\_[3,4]' AND (completed = true OR needed = false)")
    end
    return false unless answered_questions.size == 12
    return true
  end

  def issues_by(section = nil, strand = nil)
    filtered_issues = self.issues.clone
    filtered_issues.reject!{|issue| issue.section != section.to_s } if section
    filtered_issues.reject!{|issue| issue.strand != strand.to_s } if strand
    filtered_issues
  end

  def issue_attributes=(issue_attributes)
    issue_attributes.each do |attributes|
      if attributes[:id].blank?
        issues.build(attributes)
      else
        issue = issues.detect { |d| d.id == attributes[:id].to_i }
        issue.attributes = attributes
      end
    end
  end
  
  def strand_relevancies
    list = {}
    hashes['wordings'].keys.each do |strand|
      list["#{strand}_relevant".to_sym] = send("#{strand}_relevant".to_sym)
    end
    list
  end

  def save_issues
    # If we have issues
    if self.issues then
      # Loop through and process them
      self.issues.each do |d|
        if d.issue_destroy?
          d.destroy
        else
          d.save(false)
        end
      end
    end
  end

  def before_update
    @activity_clone = Activity.find(self.id)
  end

  def invisible_questions
    @@invisible_questions.clone
  end

  def invisible?(question)
    (!@@invisible_questions.include?(question) && self.existing_proposed == 2)
  end

  def dependencies(question=nil)
    return @@dependencies.clone unless question
    return @@dependencies[question].clone if @@dependencies[question]
    []
  end
  def parents(question = nil)
    return @@parents.clone unless question
    return @@parents[question].clone if @@parents[question]
    []
  end

  def after_update
    return true if @saved
    @saved = true
    to_save = {}
    if @activity_clone.send(:existing_proposed) != self.send(:existing_proposed) then
      if proposed? then
        @@invisible_questions.each do |question|
          status = self.questions.find_by_name(question.to_s)
          status.update_attributes(:needed => false)
        end
      else
        @@invisible_questions.each do |question|
          unless parents(question.to_s) == [] then
            status = self.questions.find_by_name(question.to_s)
            status.update_attributes(:needed => status.check_needed)
          else
            status = self.questions.find_by_name(question.to_s)
            status.update_attributes(:needed => true)
          end
        end
      end
    else
      Activity.get_question_names.each do |name|
        old_store = @activity_clone.send(name)
        new_store = self.send(name)
        if old_store != new_store then
          self.questions.find_by_name(name.to_s).update_status
        end
      end
      strands(true).each do |strand|
        to_save["#{strand}_percentage_importance".to_sym] = strand_percentage_importance(strand).to_i
      end
      sections.each do |section|
        to_save["#{section}_completed".to_sym] = true
        strands.each do |strand|
          to_save["#{section}_completed".to_sym] = to_save["#{section}_completed".to_sym] && completed(section.to_s, strand.to_s)
        end
      end
    end
    self.update_attributes(to_save)
  end

  def sections
    Activity.sections
  end

  def self.sections
    [:purpose, :impact, :consultation, :action_planning, :additional_work]
  end

  def self.strands
    Activity.find(:first).strands(true)
  end
  
  def impact
    strands(true).map{|strand| impact_calculation(strand)}.max
  end
  
  def strand_percentage_importance(strand)
    existing_proposed_weight = self.hashes['weights'][hashes['existing_proposed']['weight']][self.existing_proposed.to_i].to_i
    exist_proposed_max = self.hashes['weights'][hashes['existing_proposed']['weight']].max
    if self.send("#{strand}_relevant") then
      statistics_questions = self.questions.find(:all, :conditions => "needed = true")
      statistics_questions.reject!{|question| !question.name.to_s.include?(strand.to_s) || question.invisible? || question.weights.max == 0}
      total_score = statistics_questions.inject(0){|total, question| total += question.weight.to_i} + existing_proposed_weight.to_i
      maximum_score = statistics_questions.inject(0){|total, question| total += question.weights.max.to_i} + exist_proposed_max.to_i
    else
      pos_qn = self.questions.find_by_name("purpose_#{strand}_3")
      neg_qn = self.questions.find_by_name("purpose_#{strand}_4")
      total_score = pos_qn.weight + neg_qn.weight + existing_proposed_weight
      maximum_score = pos_qn.weights.max + neg_qn.weights.max + exist_proposed_max
    end
    return 0 if maximum_score == 0
    return (total_score.to_f/maximum_score.to_f)*100
  end

  def self.set_max(strand, increment)
    case strand.to_s
     when 'gender'
       @@gender_max += increment
     when 'race'
       @@race_max += increment
     when 'disability'
       @@disability_max += increment
     when 'sexual_orientation'
       @@sexual_orientation_max += increment
     when 'faith'
       @@faith_max += increment
     when 'age'
       @@age_max += increment
    end
  end

  def self.get_strand_max(strand)
    case strand.to_s
     when 'gender'
       @@gender_max
     when 'race'
       @@race_max
     when 'disability'
       @@disability_max
     when 'sexual_orientation'
       @@sexual_orientation_max
     when 'faith'
       @@faith_max
     when 'age'
       @@age_max
    end
  end

  def self.force_question_max_calculation
    @@Hashes['wordings'].keys.each do |strand|
      Activity.set_max(strand, 20) #existing_proposed increment
      Activity.get_question_names(strand).each do |name|
        question_separation = Activity.question_separation(name)
        weights = @@Hashes['weights'][Activity.new.question_wording_lookup(*question_separation)[4]]
        weights = [] if weights.nil?
        weights_max = 0
        weights.each{|weight| weights_max = weight.to_i if weight.to_i > weights_max}
        Activity.set_max(strand, weights_max)
      end
    end
  end

  def overview_strands
    {'gender' => 'gender', 'race' => 'race', 'disability' => 'disability', 'faith' => 'faith', 'sex' => 'sexual_orientation', 'age' => 'age'}
  end

  def relevant_strands
    self.overview_strands.values.select do |strand|
      self.send("#{strand}_relevant".to_sym)
    end
  end

  def strand_relevant?(strand)
    self.send("#{strand}_relevant".to_sym)
  end

  def relevant?(strand = nil)
    existing_proposed_weight = self.hashes['weights'][hashes['existing_proposed']['weight']][self.existing_proposed.to_i].to_i
    good_impact = self.questions.find(:all, :conditions => "name LIKE 'purpose_%#{strand}%_3'")
    bad_impact =  self.questions.find(:all, :conditions => "name LIKE 'purpose_%#{strand}%_4'")
    running_total = existing_proposed_weight
    running_total += good_impact.inject(0) do |tot, question|
      tot += question.weight
    end
    running_total += bad_impact.inject(0) do |tot, question|
      tot += question.weight
    end
    max = 50.0
    return (running_total/max) >= 0.35
  end

  def impact_wording(strand = nil)
    unless strand then
      impact_figure = impact 
    else
      return '-' unless self.send("#{strand}_relevant")
      impact_figure = impact_calculation(strand)
    end
    case impact_figure
      when 15
        return :high
      when 10
        return :medium
      when 5
        return :low
    end
  end
  
  def impact_calculation(strand)
    good_impact = self.send("purpose_#{strand.to_s}_3".to_sym).to_i
    bad_impact = self.send("purpose_#{strand.to_s}_4".to_sym).to_i
    good_impact = bad_impact if bad_impact > good_impact
    good_impact = hashes['weights'][question_wording_lookup(*Activity.question_separation("purpose_#{strand.to_s}_3".to_sym))[4]][good_impact]
    good_impact
  end
  
  def strands(return_all = false)
    strand_list = ['gender', 'race', 'disability', 'faith', 'sexual_orientation', 'age'].map{|strand| strand if self.send("#{strand}_relevant")||return_all}
    strand_list.compact
  end
  
  def priority_ranking(strand = nil)
    # FIXME: database should set this default for us
    ranking_boundaries = [80,70,60,50]
    rank = 5
    unless strand then
      strand_total = strands(true).inject(0) do |total, strand|
        total += priority_ranking(strand).to_i**3
      end
      strand_total = (strand_total.to_f/strands(true).size)**(1.to_f/3)
      return (strand_total.to_f + 0.5).to_i
    else
      ranking = self.send("#{strand}_percentage_importance")
      ranking_boundaries.each{|border| rank -= 1 unless ranking > border}
      return rank
    end
  end

#This method recovers questions. It allows you to search by strand or by section.
#It works by getting a list of all the columns, then removing any ones which aren't quesitons.
#NOTE: Should a new column be added to activity that isn't a question, it should also be added here.
  def self.get_question_names(section = nil, strand = nil, number = nil)
    return ["#{section}_#{strand}_#{number}".to_sym] if section && strand && number
    questions = []
    unnecessary_columns = [:impact, :use_purpose_completed,
      :purpose_completed, :impact_completed, :consultation_completed, :additional_work_completed, :action_planning_completed,
      :percentage_importance, :name, :approved, :gender_percentage_importance,
      :race_percentage_importance, :disability_percentage_importance, :sexual_orientation_percentage_importance, :faith_percentage_importance, :age_percentage_importance,
      :approver, :created_on, :updated_on, :updated_by, :function_policy, :existing_proposed, :approved_on, :gender_relevant, :faith_relevant,
      :sexual_orientation_relevant, :age_relevant, :disability_relevant, :race_relevant, :review_on, :ces_link]
    Activity.content_columns.each{|column| questions.push(column.name.to_sym)}
    unnecessary_columns.each{|column| questions.delete(column)}
    questions.delete_if{ |question| !(question.to_s.include?(section.to_s))}if section
    questions.delete_if{ |question| !(question.to_s.include?(strand.to_s))}if strand
    questions.delete_if{ |question| !(question.to_s.include?(number.to_s))} if number
    return questions
  end
  
  #TODO: Needs fixing. It currently makes a start at the display, but is not finished by any means. Won't throw any bugs though.
  def additional_work_text_lookup(strand, question)
    strand = strand.to_s
    fun_pol_indicator = ""
    existing_proposed_name = ""
    begin
      fun_pol_indicator = function_policy?.downcase #Detect whether it is a activity or a policy
      existing_proposed_name = existing_proposed?.downcase #Detect whether it is an existing activity or a proposed activity.
    rescue
    end
    wordings = hashes['wordings']
    strands = hashes['strands']
    response = ""
    choices = hashes['choices']
    case question
      when 1
        response = "If the #{fun_pol_indicator} were performed well "
        case send("purpose_#{strand}_3".to_sym)
          when 1
            response += "it would not affect #{wordings[strand]} differently."
          when 2
            response += "it would affect #{wordings[strand]} differently to a limited extent."
          when 3
            response += "it would affect #{wordings[strand]} differently to a significant extent."
          else
            response += "it would affect #{wordings[strand]} differently to a significant extent."
        end
      when 2
        response = "If the #{fun_pol_indicator} were performed badly "
        case send("purpose_#{strand}_4".to_sym)
          when 1
            response += "it would not affect #{wordings[strand]} differently."
          when 2
            response += "it would affect #{wordings[strand]} differently to a limited extent."
          when 3
            response += "it would affect #{wordings[strand]} differently to a significant extent."
          else
            response += "it would affect #{wordings[strand]} differently to a significant extent."
        end
      when 3
        response = "The performance of the #{fun_pol_indicator} in meeting the different needs of #{wordings[strand]} is "
        begin
          response += choices[2][send("impact_#{strand}_1".to_sym)].split(" - ")[1].downcase
          response += "."
        rescue
          #if it gets here, then response threw an error, meaning that the answer is "Not Answered"
          response += "not yet determined."
        end
      when 4
        issues_present = (self.send("impact_#{strand}_9".to_sym) == 1)||((self.send("consultation_#{strand}_7".to_sym) == 1))
        response += "There are #{"no " unless issues_present}performance issues that might have different implications for #{wordings[strand]}."
      when 5
        consulted_groups = (self.send("consultation_#{strand}_1".to_sym) == 1)
        consulted_experts = (self.send("consultation_#{strand}_4".to_sym) == 1)
        response += "#{wordings[strand].capitalize} have #{"not" unless consulted_groups} been consulted and stakeholders have #{"not" unless consulted_experts} been consulted."
        response += "\n"
        issues_identified = (self.send("impact_#{strand}_9".to_sym) == 1)||((self.send("consultation_#{strand}_7".to_sym) == 1))
        response += "The consultations did not identify any issues with the impact of the #{fun_pol_indicator} upon #{wordings[strand]}." unless issues_identified
      when 6
        return "The #{fun_pol_indicator} has not yet been completed sufficiently to warrant calculation of impact level and the priority ranking." unless completed(:purpose, strand.to_sym)&& completed(:impact, strand.to_sym) && completed(:consultation, strand.to_sym)
        strand = "" unless strand
        response = "For the #{strand.to_s.downcase} equality strand the Activity has an overall priority ranking of #{priority_ranking(strand.to_sym)} and a Potential Impact rating of #{impact_wording(strand.to_sym).to_s.capitalize}."
    end

    return response
  end
  #This activity returns the wording of a particular question. It takes a section strand and question number as arguments, and returns that specific question.
  #It can also be passed nils, and in that event, it will automatically return an array containing all the values that corresponded to the nils. Hence, to return all
  #questions and their lookup types, just func.question_wording_lookup suffices.
  def question_wording_lookup(section = nil, strand = nil, question = nil)
    fun_pol_indicator = case fun_pol_number
      when 0
        "function"
      when 1
        "policy"
      else
        "---------"
    end
    exist_prop_indicator = case exist_prop_number
      when
        "existing"
      when 1
        "proposed"
      else
        "---------"
    end
    section = section.to_s
    strand = strand.to_s
    question = question.to_i unless question.nil?
    strands = hashes['strands']
    wordings = hashes['wordings']
    questions = hashes['questions']
    overall_questions = hashes['overall_questions']
    descriptive_term = hashes['descriptive_terms_for_strands']
    response = {}
    #First recursively decide on all the strands
    unless strand != "" then
      strands.each_key{|new_strand| response[new_strand] = (question_wording_lookup(section, new_strand, question))[new_strand]}
      return response
    end
    #Then decide which hash to use
    if strand.downcase == 'overall' then
      query_hash = overall_questions
    else
      query_hash = questions
    end
    #then recursively sort by section
    unless section != "" then
      query_hash.each_key do |new_section|
        if response[strand] then
          response[strand][new_section] = question_wording_lookup(new_section, strand, question)[strand][new_section]
        else
          response[strand] = {new_section => question_wording_lookup(new_section, strand, question)[strand][new_section]}
        end
      end
      return response
    end
    #finally, recursively find all the questions
    unless question then
      query_hash[section].each_key do |question_name|
        if response[strand] then
          response[strand][section][question_name] = question_wording_lookup(section, strand, question_name)
        else
          response[strand] = {section => {question_name => question_wording_lookup(section, strand, question_name)}}
        end
      end
      return response
    end
    label = query_hash[section][question]['label'][self.fun_pol_number][self.exist_prop_number].to_s
    type = query_hash[section][question]['type']
    choices = query_hash[section][question]['choices']
    help_object = HelpText.find_by_question_name("#{section}_#{strand}_#{question}")
    if help_object.nil?
      help_text = ""
    else
      if (exist_prop_indicator.include? "-") || (fun_pol_indicator.include? "-") then
        help_text = ""
      else
        text_to_send = "#{exist_prop_indicator}_#{fun_pol_indicator}"
        help_text = help_object.send(text_to_send.to_sym)
      end
    end
    weights = query_hash[section][question]['weights']
    label = eval(%Q{<<"DELIM"\n} + label.to_s + "\nDELIM\n") rescue nil
    help_text = eval(%Q{<<"DELIM"\n} + help_text.to_s + "\nDELIM\n") rescue nil
    label.chop! unless label.nil?
    help_text.chop! unless help_text.nil?
    return [label, type, choices, help_text, weights]
  end

    #This takes a method in the form of :section_strand_number and turns it into an array [section, strand, number]
  def self.question_separation(question)
    Question.fast_split(question)
  end

  #This returns any dependencies of a question
    def dependent_questions(question)
      question = question.to_s
      yes_value = hashes['yes_value']
      no_value = hashes['no_value']
      if question.include?("overall") then
        query_hash = hashes['overall_questions']
      else
        query_hash = hashes['questions']
      end
      segments = Activity.question_separation(question)
      if segments then
        section = segments[0]
        strand = segments[1]
        question_name = segments[2]
        dependencies = query_hash[section.to_s][question_name.to_i]['dependent_questions']
        dependencies.gsub!("yes_value", yes_value.to_s)
        dependencies.gsub!("no_value", no_value.to_s)
        dependencies = dependencies.split(" ")
        return nil if dependencies == []
        dependencies[0] = eval(%Q{<<"DELIM"\n} + dependencies[0] + "\nDELIM\n")
        dependencies[0].chop!
        return [dependencies]
      else
        return nil
      end
    end

  def check_response(response) #Check response verifies whether a response to a question is correct or not.
    checker = !(response.to_i == 0)
    checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
    return checker
  end


end
