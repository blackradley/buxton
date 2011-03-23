#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
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
  belongs_to :completer, :class_name => "User"
  belongs_to :approver, :class_name => "User"
  belongs_to :service_area
  
  has_many :activity_strategies, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_and_belongs_to_many :projects

  validates_presence_of :name, :message => 'All activities must have a name.'
  validates_uniqueness_of :ref_no, :message => 'Reference number must be unique', :if => :ref_no?
  validates_presence_of :completer, :approver
  validates_presence_of :service_area
  validates_associated :completer, :approver
#  validates_associated :questions
  # validates_uniqueness_of :name, :scope => :directorate_id
  
  before_save :set_approved, :update_completed
  after_create :create_questions_if_new

  after_update :save_issues
  
  include FixInvalidChars
  
  before_save :fix_fields
  
  accepts_nested_attributes_for :questions
  
  def progress
    unless self.started
      return "NS"
    end
    if !(self.approved == "submitted")
      return "IA"
    end
    if self.approved == "submitted"
      return "FA"
    end
  end
  
  def directorate
    self.service_area ? self.service_area.directorate : nil
  end
  
  def directorate_id
    self.service_area ? self.service_area.directorate.id : nil
  end
  
  def directorate=(id)
  end
  
  def approver_email
    if self.approver
      self.approver.email
    else
      ""
    end
  end
  
  def approver_email=(email)
    self.approver_id = User.live.find_by_email(email)
  end
  
  def completer_email
    if self.completer
      self.completer.email
    else
      ""
    end
  end
  
  def completer_email=(email)
    self.completer_id = User.live.find_by_email(email)
  end
  
  def fix_fields
    self.attributes.each_pair do |key, value|
      self.attributes[key] = fix_field(value)
    end
  end
  
  def activity_type
    if self.started then
      [self.existing_proposed?, self.function_policy?].join(' ')
    else
      '-'
    end
  end
  
  ## One statement per question is far too slow
  ## Execute SQL directly for a single INSERT statement, using SELECT and JOIN.
  ## See http://blog.sqlauthority.com/2007/06/08/sql-server-insert-multiple-records-using-one-insert-statement-use-of-union-all/
  def create_questions_if_new
    # Initialise a question, for every question name, if this is a new record
    # 
    # 
    data = File.open(Rails.root + "config/questions.yml"){|yf| YAML::load( yf ) }
    dependents = {}
    Activity.question_setup_names.each do |section, strand_list|
      strand_list.each do |strand, question_list|
        question_list.each do |question_number|
          question_data = strand.to_s == "overall" ? data["overall_questions"]['purpose'][question_number] : data["questions"][section.to_s][question_number]
          begin
            wordings = data['wordings']
            descriptive_term = data['descriptive_terms_for_strands']
            help_text = question_data["help"][0][0]
            question_label = question_data['label'][0][0]
            puts help_text.inspect
            help_text = eval(%Q{<<"DELIM"\n} + help_text.to_s + "\nDELIM\n") rescue nil
            help_text.chop! unless help_text.nil?
            puts question_label.inspect
            question_label = eval(%Q{<<"DELIM"\n} + question_label.to_s + "\nDELIM\n") rescue nil
            basic_attributes = {:input_type => question_data["type"], :needed => question_data["dependent_questions"].blank?,
                                 :help_text => help_text, :label => question_label, :name => "#{section}_#{strand}_#{question_number}", 
                                 :strand => strand, :section => section}
            basic_attributes[:choices] = data['choices'][question_data['choices']] if question_data['choices']
            question = self.questions.build(basic_attributes)
            question.save!
          rescue
            raise question_data.inspect
          end
          if !question_data["dependent_questions"].blank?
            dependent = question_data["dependent_questions"].split(" ")
            value = dependent[1] == "yes_value" ? 1 : 2
            dep_name = dependent[0].sub('#{strand}', strand.to_s)
            dependents[question] ||= []
            dependents[question] << [dep_name, value]
          end
        end
      end
    end
    dependents.each do |child, parents|
      parents.each do |parent_q, value|
        self.questions.find_by_name(parent_q).dependencies.create!(:child_question => child, :required_value => value)
      end
    end
  end

  def set_approved
    if self.approved? then
      if !self.approved_on then
        self.approved_on = Time.now
      end
    else
      self.approved_on = nil
    end
  end

  def approved?
    self.approved == "approved"
  end
  
  def show_full_assessment?
    self.strands(true).each do |strand|
      return true if self.strand_required?(strand)
    end
    false
  end
  
  #broken with section and strand passed!
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
      impact_answer = self.questions.where(:name => impact_qn).first.response.to_i
      consultation_answer = self.questions.where(:name => consultation_qn).first.response.to_i
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
    answered_questions = self.questions.where(:name => ["purpose_overall_2", "purpose_overall_11", "purpose_overall_12"]).where("completed = true OR needed = false")
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
      answered_questions += self.questions.find(:all, :conditions => "name REGEXP 'purpose\_#{strand.to_s}\_3' AND (completed = true OR needed = false)")
    end
    return false unless answered_questions.size == 6
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

  
  def update_completed
    sections.each do |section|
      self.send("#{section}_completed=".to_sym, true)
      strands.each do |strand|
        self.send("#{section}_completed=".to_sym, self.send("#{section}_completed".to_sym) && completed(section.to_s, strand.to_s))
      end
    end
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

  def overview_strands
    {'gender' => 'gender', 'race' => 'race', 'disability' => 'disability', 'faith' => 'faith', 'sex' => 'sexual_orientation', 'age' => 'age'}
  end

  def strand_required?(strand)
    self.questions.where(:name => "purpose_#{strand.to_s}_3").first.response == 1
  end
  
  def strand_relevant?(strand)
    self.send("#{strand.to_s}_relevant")
  end
  
  def update_relevancies!
    strand_attributes = {}
    self.strands(true).each do |strand|
      if self.questions.where(:name => "purpose_#{strand.to_s}_3").first.response == 1
        strand_attributes["#{strand}_relevant"] =  true
      else
        strand_attributes["#{strand}_relevant"] = false
      end
    end
    self.update_attributes(strand_attributes)
  end

  def strands(return_all = false)
    strand_list = ['gender', 'race', 'disability', 'faith', 'sexual_orientation', 'age'].map{|strand| strand if self.send("#{strand}_relevant")||return_all}
    strand_list.compact
  end

  def self.strands
    ['gender', 'race', 'disability', 'faith', 'sexual_orientation', 'age']
  end
  
  def types
    ["function", "policy"]
  end
  
  def proposed?
    self.existing_proposed == 2
  end
  
  def statuses
    ["existing", "proposed"]
  end
  
  def self.question_setup_names
    {:purpose =>          { :overall => [2,5,6,7,8,9,11,12],
                            :race => [3],
                            :disability => [3],
                            :sexual_orientation => [3],
                            :gender => [3],
                            :faith => [3],
                            :age => [3]
                          },
      :impact =>          { :race => [1,2,3,4,5,6,7,8,9],
                            :disability => [1,2,3,4,5,6,7,8,9],
                            :sexual_orientation => [1,2,3,4,5,6,7,8,9],
                            :gender => [1,2,3,4,5,6,7,8,9],
                            :faith => [1,2,3,4,5,6,7,8,9],
                            :age => [1,2,3,4,5,6,7,8,9]
                          },
      :consultation =>    { :race => [1,2,3,4,5,6,7],
                            :disability => [1,2,3,4,5,6,7],
                            :sexual_orientation => [1,2,3,4,5,6,7],
                            :gender => [1,2,3,4,5,6,7],
                            :faith => [1,2,3,4,5,6,7],
                            :age => [1,2,3,4,5,6,7]
                          },    
      :additional_work => { :race => [1,2,3,4,6],
                            :disability => [1,2,3,4,6],
                            :sexual_orientation => [1,2,3,4,6],
                            :gender => [1,2,3,4,6],
                            :faith => [1,2,3,4,6],
                            :age => [1,2,3,4,6]
                          }
    }
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
        response = "For the #{(strand.to_s.downcase == 'faith') ? 'religion or belief' : strand.to_s.downcase} equality strand the Activity has an overall priority ranking of #{priority_ranking(strand.to_sym)} and a Potential Impact rating of #{impact_wording(strand.to_sym).to_s.capitalize}."
    end

    return response
  end
  
  def check_response(response) #Check response verifies whether a response to a question is correct or not.
      checker = !(response.to_i == 0)
      checker = ((response.to_s.length > 0)&&response.to_s != "0") unless checker
      return checker
    end
    
   def sentence_desc(strand)
     case strand.to_s
     when 'race'
       'ethnicity'
     when 'faith'
       'religion or belief'
     else
       strand.to_s.titleize.downcase
     end
   end

end
