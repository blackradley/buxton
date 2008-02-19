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
  belongs_to :activity_manager, :dependent => :destroy
  belongs_to :directorate
  # Fake belongs_to :organisation, :through => :directorate
  delegate :organisation, :organisation=, :to => :directorate

  has_many :activity_strategies, :dependent => :destroy
  has_many :issues, :dependent => :destroy

  validates_presence_of :name, :message => 'All activities must have a name.'
  validates_presence_of :activity_manager
  validates_associated :activity_manager
  # validates_uniqueness_of :name, :scope => :directorate_id

  has_many :questions, :dependent => :destroy

  attr_accessor :activity_clone, :overall_completed_issues, :completed_strategies, :made_change, :saved
  before_save :set_approved

  after_update :save_issues
  
  def activity_type
    if self.started then
      [self.existing_proposed?, self.function_policy?].join(' ')
    else
      '-'
    end
  end

  def header(header_placing)
    fun_pol = self.function_policy.to_i
    fun_pol -= 1
    fun_pol = 0 if fun_pol == -1
    exist_prop = self.existing_proposed
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

  def set_approved
    if self.approved == 1 then
      if !self.approved_on then
        self.approved_on = Time.now.gmtime
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

  #27-Stars Joe: percentage_answered allows you to find the percentage answered of a group of questions.
  def percentage_answered(section = nil, strand = nil)
    issue_strand = []
    number_answered = 0
    total = 0
    #Check whether each question is completed. If it is, add one to the amount that are completed. Then add one to the total.
    like = [section, strand].join('_')
    # Find all incomplete questions with the given arguments
    needed = section != :purpose
    number_answered += self.questions.find(:all, :conditions => "name LIKE '%#{like}%' AND completed = true#{" AND needed = true" if needed}").size
    not_needed_questions = self.questions.find(:all, :conditions => "name LIKE '%#{like}%'#{" AND needed = false" if needed}").size
    total += Activity.get_question_names(section, strand).size - not_needed_questions
    #If you don't specify a section, or your section is action planning, consider issues as well.
    unless section && !(section == :action_planning) then
      #First we calculate all the questions, in case there is a nil.
      questions = Activity.get_question_names(:consultation, strand, 7)
      questions << Activity.get_question_names(:impact, strand, 9)
      questions.flatten!
      questions.each do |question|
        strand = Activity.question_separation(question)[1]
        if section
          lookups_required = (self.send(question) == 1 ||self.send(question) == 0 || self.send(question).nil?)
        else
          lookups_required = (self.send(question) == 2)
        end
        if lookups_required then
          issue_strand = self.issues.clone
          issue_strand.delete_if{|issue_name| issue_name.strand != strand.to_s}
          return 0 if (section == :action_planning && issue_strand.length == 0)
          issue_names = []
          Issue.content_columns.each{|column| issue_names.push(column.name)}
          issue_names.delete('strand')
          issue_strand.each do |issue_name|
            issue_names.each do |name|
              if check_response(issue_name.send(name.to_sym)) then
                number_answered += 1
              end
              total += 1
            end
          end
        end
      end
    end
    #If you don't suggest a section, or your section is purpose, then consider strategies as well.
    unless section && !(section == :purpose) then
      self.activity_strategies.each do |strategy|
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

   #The started tag allows you to check whether a activity, section, or strand has been started. This is basically works by running check_percentage, but as
   #soon as it finds a true value, it breaks out of the loop and returns false. If you request a activity started from it, it checks whether the 2 questions
   #that you have to answer(activity/policy and proposed/overall) have been answered or not, and if they have not been answered, then no others can be
   # and if they have, then the activity is by definition started
  def started(section = nil, strand = nil)
    return (self.existing_proposed.to_i*self.function_policy.to_i) != 0 if (section.nil? && strand.nil?)
    like = [section, strand].join('_')
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

  #This allows you to check whether a activity, section or strand has been completed. It runs like started, but only breaking when it finds a question
  #that has not been answered. Hence, it is at its slowest where there is a single unanswered question in each section. In worst case it has to run
  #through every question bar n where n is the number of activitys, making it a O(n) algorithm.
  def completed(section = nil, strand = nil)
    if section || strand then
      unless section == :action_planning then
        # BEGIN NEW IMPLEMENTATION
          # Check on issues first, if appropriate
          if (section == :impact) || (section == :consultation) then
            # TODO: have this handle when no strand is given
            issues_question = case section
            when :impact
              "impact_#{strand}_9"
            when :consultation
              "consultation_#{strand}_7"
            end
            if self.send(issues_question.to_sym) == 1 then
              issues = self.issues_by(section, strand)
              return false if issues.size == 0
            end
          end
          like = [section, strand].join('_')
          needed = (section != :purpose)
          # Find all incomplete questions with the given arguments
          # Either completed must be true, or needed must be false for this to evaluate. There is no need for both.
          answered_questions = self.questions.find(:all, :conditions => "name LIKE '%#{like}%' AND (completed = true OR needed = false)")
          all_questions = Activity.get_question_names(section, strand)
          # Have all the questions been answered?
          if answered_questions.size == (all_questions.size) then
            #if they have all been completed, then it must be done.
            return true
          else
            # If some questions have not been answered, we must not be complete
            return false
          end
        # END NEW IMPLEMENTATION
        # BEGIN OLD IMPLEMENTATION
          # Activity.get_question_names(section, strand).each{|question| unless check_question(question) then return false end}
        # END OLD IMPLEMENTATION
      end
    else
      return false unless self.overall_completed_questions && self.purpose_completed && self.action_planning_completed
    end
    unless (section && !(section == :action_planning)) then
      #First we calculate all the questions, in case there is a nil.
      questions = Activity.get_question_names(:consultation, strand, 7)
      questions << Activity.get_question_names(:impact, strand, 9)
      questions.flatten!
      questions.each do |question|
        strand = Activity.question_separation(question)[1]
        if section
          lookups_required = (self.send(question) == 1 ||self.send(question) == 0 || self.send(question).nil?) && self.send("#{strand}_relevant".to_sym)
        else
          lookups_required = (self.send(question) == 2) && !self.send("#{strand}_relevant".to_sym)
        end
        if lookups_required then
          issue_strand = self.issues.clone
          issue_strand.delete_if{|issue_name| issue_name.strand != strand.to_s}
          return false if (section == :action_planning && issue_strand.length == 0)
          issue_names = []
          Issue.content_columns.each{|column| issue_names.push(column.name)}
          issue_names.delete('strand')
          issue_strand.each do |issue_name|
            issue_names.each do |name|
              unless check_response(issue_name.send(name.to_sym)) then
                return false
              end
            end
          end
        end
      end
      unless self.overall_completed_issues then
        self.update_attributes(:overall_completed_issues => true, :action_planning_completed => true) unless (section || strand)
      end
    end
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
  
  def dependencies(question=nil)
    return @@dependencies.clone unless question
    @@dependencies[question]
    
  end
  
  def after_update
    return true if @saved
    @saved = true
    to_save = {}
    check_impact = false
    to_save[:overall_completed_strategies] = true if self.purpose_completed
    if @activity_clone.send(:existing_proposed) != self.send(:existing_proposed) then
      old_value = @activity_clone.send(:existing_proposed).to_i - 1
      new_value = self.send(:existing_proposed).to_i - 1
      old_weight = self.hashes['weights'][self.hashes['existing_proposed']['weight']][old_value]
      new_weight = self.hashes['weights'][self.hashes['existing_proposed']['weight']][new_value]
      old_weight = 0 if @activity_clone.send(:existing_proposed).to_i == 0
      new_weight = 0 if self.send(:existing_proposed).to_i == 0
      strands.each do |strand|
        strand_max = Activity.get_strand_max(strand)
        old_importance = self.send("#{strand}_percentage_importance".to_sym)
        new_importance = old_importance + (new_weight.to_f - old_weight.to_f)*100/strand_max
        new_importance += 0.5 #true integer conversion with rounding
        to_save["#{strand}_percentage_importance".to_sym] = new_importance.to_i
      end
      if new_value == 1 then
        @@invisible_questions.each do |question|
          status = self.questions.find_or_initialize_by_name(question.to_s)
          status.update_attributes(:needed => false)
        end
      end
    else
      strand_relevancies.each do |strand_name, value|
        if @activity_clone.send(strand_name) != value then
          Activity.get_question_names(nil, strand_name.to_s.gsub("_relevant", "")).each do |question_name|
            next if question_name.to_s.include? "purpose"
            question = self.questions.find_or_initialize_by_name(question_name.to_s)
            question.update_attributes(:needed => value)
          end
        end
      end       
      Activity.get_question_names.each do |name|
        old_store = @activity_clone.send(name)
        new_store = self.send(name)
        if old_store != new_store then
          to_change = []
          check_result = check_question(name)
          to_change.push([name, check_result])
          unless dependencies(name.to_s).nil? then
            dependencies(name.to_s).each do |dependent|
              re_eval = dependent[0].to_s.clone
              check_re_eval = check_question(re_eval)
              to_change.push([re_eval.clone, check_re_eval])
            end
          end
          to_change.each do |question_name, completed_result|
            status = self.questions.find_or_initialize_by_name(question_name.to_s)
            status.update_attributes(:completed => !!completed_result) #cheap cast to bool. Not a cargocult ;)
            question_name = question_name.to_sym
            separated_question = Activity.question_separation(question_name)
            question_details = question_wording_lookup(*separated_question)
            unless separated_question[1].to_s == 'overall' then
              if separated_question[0].to_s == 'purpose' && separated_question[1].to_s != "overall" then
                check_impact = true if old_store.to_i*5 == self.impact.to_i
              end
              old_importance = self.send("#{separated_question[1]}_percentage_importance".to_sym)
              old_importance = to_save["#{separated_question[1]}_percentage_importance".to_sym] if to_save["#{separated_question[1]}_percentage_importance".to_sym]
              old_position = old_store.to_i - 1 unless old_store.to_i == 0
              new_position = new_store.to_i - 1 unless new_store.to_i == 0
              old_weight = self.hashes['weights'][question_details[4].to_i][old_store.to_i].to_i unless old_store.to_i == 0
              weight = self.hashes['weights'][question_details[4].to_i][new_store.to_i].to_i unless new_store.to_i == 0
              old_weight = 0 if old_store.to_i == 0
              new_weight = 0 if new_store.to_i == 0
              new_importance = ((weight.to_f - old_weight.to_f)/Activity.get_strand_max(separated_question[1]))*100 + old_importance.to_i
              if new_importance != old_importance then
                to_save["#{separated_question[1]}_percentage_importance".to_sym] = (new_importance + 0.5).to_i
              end
            end
          end
        end
      end
      if check_impact then
        new_impact = 5
        impact_questions = Activity.get_question_names('purpose', nil, 3) + Activity.get_question_names('purpose', nil, 4)
        impact_questions.each do |iq|
          new_impact = self.send(iq).to_i*5 if new_impact < self.send(iq).to_i*5
        end
        to_save[:impact] = new_impact if new_impact != self.impact
      end
      sections = [:purpose, :impact, :consultation, :action_planning, :additional_work]
      sections.each do |section|
        sec_completed = true
        needed = (section != :purpose)
        section_questions = self.questions.find(:all, :conditions => "name LIKE '%#{section.to_s}%'#{" AND needed = true" if needed}") 
        remove_qns = self.questions.find(:all, :conditions => "name LIKE '%#{section.to_s}%' AND needed = false#{" AND needed = false" if needed}").size
        total = Activity.get_question_names(section).size - remove_qns
        sec_completed = false if section_questions.size != total
        section_questions.each{|question| sec_completed = false unless question.completed || (!question.needed && needed)}
        to_save["#{section}_completed".to_sym] = sec_completed
      end
      to_save[:overall_completed_strategies] = to_save[:purpose_completed] if to_save[:overall_completed_strategies]
      overall_comp = !(self.questions.find(:all, :conditions => 'completed = false').size > 0)
      overall_comp = false if self.questions.size != Activity.get_question_names.size
      to_save[:overall_completed_questions] = overall_comp unless overall_comp == self.overall_completed_questions
    end
    self.update_attributes(to_save)
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
      tot += self.hashes['weights'][hashes['questions']['purpose'][3]['weights'].to_i][self.send(question.name.to_sym).to_i].to_i
    end
    running_total += bad_impact.inject(0) do |tot, question|
      tot += self.hashes['weights'][hashes['questions']['purpose'][4]['weights'].to_i][self.send(question.name.to_sym).to_i].to_i
    end
    max = 50.0
    return (running_total/max) >= 0.35    
  end

  def impact_wording(strand = nil)
    unless strand then
      case self.impact
        when 15
          return :high
        when 10
          return :medium
        when 5
          return :low
        else
          return '-'
      end
    else
      return '-' unless self.send("#{strand}_relevant")
      good_impact = self.send("purpose_#{strand.to_s}_3".to_sym).to_i
      bad_impact = self.send("purpose_#{strand.to_s}_4".to_sym).to_i
      good_impact = bad_impact if bad_impact > good_impact
      good_impact = hashes['weights'][question_wording_lookup(*Activity.question_separation("purpose_#{strand.to_s}_3".to_sym))[4]][good_impact]
      case good_impact
        when 15
          return :high
        when 10
          return :medium
        when 5
          return :low
      end
    end
  end
  def strands
    strand_list = ['gender', 'race', 'disability', 'faith', 'sexual_orientation', 'age'].map{|strand| strand if self.send("#{strand}_relevant")}
    strand_list.compact
  end
  def priority_ranking(strand = nil)
    # FIXME: database should set this default for us
    self.update_attribute(:percentage_importance, 0) unless self.percentage_importance
    ranking_boundaries = [80,70,60,50]
    rank = 5
    unless strand then
      strand_total = strands.inject(0) do |total, strand|
        total += priority_ranking(strand)**3
      end
      strand_total = (strand_total.to_f/strands.size)**(1.to_f/3)
      return (strand_total + 0.5).to_i
    else
      return '-' if self.send("#{strand}_relevant")
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
	  unnecessary_columns = [:impact, :overall_completed_questions, :overall_completed_strategies, :use_purpose_completed,
      :purpose_completed, :impact_completed, :consultation_completed, :additional_work_completed, :action_planning_completed,
      :overall_completed_issues, :overall_started, :percentage_importance, :name, :approved, :gender_percentage_importance,
      :race_percentage_importance, :disability_percentage_importance, :sexual_orientation_percentage_importance, :faith_percentage_importance, :age_percentage_importance,
      :approver, :created_on, :updated_on, :updated_by, :function_policy, :existing_proposed, :approved_on, :gender_relevant, :faith_relevant,
      :sexual_orientation_relevant, :age_relevant, :disability_relevant, :race_relevant, :review_on]
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
        response += "Groups representing #{wordings[strand]} have #{"not " unless consulted_groups}been consulted and"
        response += " experts have #{"not " unless consulted_experts}been consulted."
        response += "\n"
        issues_identified = (self.send("consultation_#{strand}_7".to_sym) == 1)
        response += "The consultations did not identify any issues with the impact of the #{fun_pol_indicator} upon #{wordings[strand]}."
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
    help = query_hash[section][question]['help'][self.fun_pol_number][self.exist_prop_number].to_s
    weights = query_hash[section][question]['weights']
    label = eval(%Q{<<"DELIM"\n} + label.to_s + "\nDELIM\n") rescue nil
    help = eval(%Q{<<"DELIM"\n} + help.to_s + "\nDELIM\n") rescue nil
    label.chop! unless label.nil?
    help.chop! unless help.nil?
    return [label, type, choices, help, weights]
  end

    #This takes a method in the form of :section_strand_number and turns it into an array [section, strand, number]
  def self.question_separation(question)
    hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml") unless hashes
    question = question.to_s
    if question.include?("overall") then
      query_hash = hashes['overall_questions']
    else
      query_hash = hashes['questions']
    end
    section = ""
    question_number = ""
    query_hash.keys.each{|section_name|section = section_name.to_sym if question.include?(section_name.to_s)}
    question.gsub!(section.to_s, "")
    question = question.split("_")
    question_number = question.pop
    strand = question.inject(""){|init_name, parts_name| init_name += "#{parts_name} "}
    strand.strip!
    strand.gsub!(" ", "_")
    return [section.to_sym, strand.to_sym, question_number] if (!section.blank? && !strand.blank? && question_number)
    return nil
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

private

#Check question takes a single question as an argument and checks if it has been completed, and that any dependent questions have been answered.
  def check_question(question)
    question = question.to_sym
    dependency = dependent_questions(question)
    if dependency then
      response = send(question)
      dependant_correct = true
      dependency.each do #For each dependent question, check that it has the correct value
	      |dependent|
		    dependent[1] = dependent[1].to_i
        dependent_solution = send(dependent[0])
        dependant_correct = dependant_correct && !(dependent_solution ==dependent[1] || dependent_solution == 0 || dependent_solution.nil?)
	    end
      if dependant_correct then #If you don't need to answer this question, automatically give it a completed status
        return :no_need
      else
        return check_response(response) #Else check it as normal
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


end
