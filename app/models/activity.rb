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
require 'csv'

class Activity < ActiveRecord::Base
  attr_protected

  belongs_to :completer, :class_name => "User"
  belongs_to :approver, :class_name => "User"
  belongs_to :qc_officer, :class_name => "User"
  belongs_to :service_area
  has_many :activity_strategies, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :task_group_memberships

  validates_presence_of :service_area
  validates :name, :presence => {:full_message => 'Your EA must have a name'}
  validates :approver, :presence => {:full_message =>"Your EA has to have a Senior Officer"}
  validates :completer, :presence => {:full_message =>"Your EA has to have a Task Group Manager"}
  validates :qc_officer, :presence => {:full_message =>"Your EA has to have a Quality Control Officer"}
  validates :review_on, :presence => {:full_message =>"You must enter the review date for your EA"}
  # validates_presence_of :name, :message => 'All activities must have a name.'
  # validates_presence_of :completer, :approver
  # validates_presence_of :service_area
  validates_associated :completer, :approver, :qc_officer
  has_many :helpers, :through => :task_group_memberships, :source => :user
  # validates_associated :questions
  # validates_uniqueness_of :name, :scope => :directorate_id

  validate :senior_advisor_and_task_group_manager_cannot_be_the_same_person

  before_update :set_approved, :update_completed
  after_create :create_questions_if_new

  default_scope -> { where :is_rejected => false }

  scope :active,  lambda{
    joins(:service_area => :directorate).where(:service_areas => {:retired => false}).where( :directorates => {:retired => false}).readonly(false)
  }
  include FixInvalidChars

  before_save :fix_fields, :set_recently_rejected

  scope :ready, -> { where :ready => true }

  accepts_nested_attributes_for :questions
  accepts_nested_attributes_for :issues, :allow_destroy => true#, :reject_if => proc { |attributes| attributes['description'].blank? }

  before_validation :mark_empty_issues
  attr_accessor :task_group_member

  def senior_advisor_and_task_group_manager_cannot_be_the_same_person
    if approver && completer && approver.email == completer.email
      errors.add( :approver, "cannot be the same as the task group manager" )
    end
  end

  def set_recently_rejected
    self.recently_rejected = false
    true
  end

  def previous_activity
    return @previous_activity if @previous_activity
    @previous_activity = Activity.unscoped.where(:previous_activity_id => self.id).first
  end

  def parent_activity
    return @parent_activity if @parent_activity
    @parent_activity = Activity.unscoped.where(:id => self.previous_activity_id).first
  end

  def mark_empty_issues
    issues.select{|i| i.description.blank?}.each do |issue|
      issue.mark_for_destruction
    end
  end

  #TODO: Fix this
  def service_area=(arg)
    if arg.is_a?(String) || arg.is_a?(Fixnum)
      self.service_area_id = arg.to_i
    else
      self.service_area_id = arg.id
    end
  end

  def fields_complete
    return false if self.name.blank?
    return false if self.approver.blank?
    return false if self.completer.blank?
    return false if self.review_on.blank?
    return true
  end

  def generate_ref_no
    self.update_attribute( :ref_no, "EA#{sprintf("%06d", self.id)}" )
  end

  def progress
    if self.recently_rejected
      return "R"
    end
    if !self.ready
      return "PC"
    end
    if self.approved
      return "A"
    end
    unless self.started
      return "NS"
    end
    if self.completed(:purpose) && self.questions.where("completed = true AND (section != 'purpose' OR name = 'purpose_overall_14') ").size > 0
      return "FA"
    end
    if self.questions.where("name like 'purpose_%' and completed = true and needed = true AND name not like 'purpose_overall_14'").size > 0
      return "IA"
    end
  end

  def full_progress
    case self.progress
    when "A"
      "Approved"
    when "NS"
      "Not Started"
    when "FA"
      "Full Assessment"
    when "IA"
      "Initial Assessment"
    end
  end

  def associated_users
    user_list = [completer, approver, qc_officer] + self.task_group_memberships.map(&:user)
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
    @approver_email ||= approver.try(:email) || ""
  end

  def approver_email=(email)
    if user = User.live.find_by(email: email)
      self.approver_id = user.id
    else
      self.approver_id = nil
    end
  end

  def completer_email
    @completer_email ||= completer.try(:email) || ""
  end

  def completer_email=(email)
    if user = User.live.find_by(email: email)
      self.completer_id = user.id
    else
      self.completer_id = nil
    end
  end

  def qc_officer_email
    @qc_officer_email ||= qc_officer.try(:email) || ""
  end

  def qc_officer_email=(email)
    if user = User.live.find_by(email: email)
      self.qc_officer_id = user.id
    else
      self.qc_officer_id = nil
    end
  end

  def fix_fields
    self.attributes.each_pair do |key, value|
      self.attributes[key] = fix_field(value)
    end
  end

  # def reset_question_texts(destroy_purpose = true)
  #  data = File.open(Rails.root + "config/questions.yml"){|yf| YAML::load( yf ) }
  #  help_texts = CSV.read( 'doc/helptext.csv' )
  #  dependents = {}
  #  Question.where(:name => ["purpose_overall_11", "purpose_overall_12"]).each(&:destroy) if destroy_purpose
  #  Activity.question_setup_names.each do |section, strand_list|
  #    strand_list.each do |strand, question_list|
  #      question_list.each do |question_number|
  #         question_data = strand.to_s == "overall" ? data["overall_questions"]['purpose'][question_number] : data["questions"][section.to_s][question_number]

  #         idx = help_texts.index{|x| x[0]=="#{section}_#{strand}_#{question_number}"}
  #         help = idx ? help_texts[ idx ][2] : ''
  #         old_texts = {:label => question_data['label'].dup, :help_text => help}

  #         texts = {}
  #         old_texts.each do |key, value|
  #           #some questions have extra wordings on a per section and strand basis. The exceptions for this are codified here
  #           new_value = value.to_s
  #           new_value.gsub!('#{wordings[strand]}', data["wordings"][strand.to_s].to_s)
  #           new_value.gsub!('#{wordings[strand_short]}', data["strands"][strand.to_s].to_s)
  #           new_value.gsub!('#{descriptive_term[strand]}', data["wordings"][strand.to_s].to_s)
  #           new_value.gsub!('#{"different " if strand == "gender"}', strand.to_s == "gender" ? 'different' : '')
  #           new_value.gsub!('#{sentence_desc(strand)}', sentence_desc(strand.to_s))
  #           if data["extra_strand_wordings"][section.to_s] && data["extra_strand_wordings"][section.to_s][question_number]
  #             new_value.gsub!("\#{data[\"extra_strand_wordings\"][\"#{section}\"][#{question_number}][strand]}", data["extra_strand_wordings"][section.to_s][question_number][strand.to_s].to_s)
  #             new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_word"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_word'][strand.to_s].to_s)
  #             new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_paragraph"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_paragraph'][strand.to_s].to_s)
  #           end
  #           texts[key] = new_value
  #         end
  #         basic_attributes = { :help_text => texts[:help_text], :label => texts[:label]}
  #         basic_attributes[:choices] = data['choices'][question_data['choices']] if question_data['choices']
  #         questions = self.questions.where(name: "#{section}_#{strand}_#{question_number}")
  #         questions.each do |q|
  #           q.update_attributes(basic_attributes)
  #           q.save!
  #         end
  #       end
  #     end
  #   end
  # end
  ## One statement per question is far too slow
  ## Execute SQL directly for a single INSERT statement, using SELECT and JOIN.
  ## See http://blog.sqlauthority.com/2007/06/08/sql-server-insert-multiple-records-using-one-insert-statement-use-of-union-all/
  def create_questions_if_new
    # Initialise a question, for every question name, if this is a new record
    #
    #
    #
    data = File.open(Rails.root + "config/questions.yml"){|yf| YAML::load( yf ) }
    help_texts = CSV.read( 'doc/helptext.csv' )
    dependents = {}
    Activity.question_setup_names.each do |section, strand_list|
      strand_list.each do |strand, question_list|
        question_list.each do |question_number|
          question_data = strand.to_s == "overall" ? data["overall_questions"]['purpose'][question_number] : data["questions"][section.to_s][question_number]
          idx = help_texts.index{|x| x[0]=="#{section}_#{strand}_#{question_number}"}
          help = idx ? help_texts[ idx ][2] : ''
          old_texts = {:label => question_data['label'].dup, :help_text => help}
          texts = {}
          old_texts.each do |key, value|
            #some questions have extra wordings on a per section and strand basis. The exceptions for this are codified here
            new_value = value.to_s
            new_value.gsub!('#{wordings[strand]}', data["wordings"][strand.to_s].to_s)
            new_value.gsub!('#{wordings[strand]}', data["wordings"][strand.to_s].to_s)
            new_value.gsub!('#{wordings[full_analysis_required]}', data['wordings']['full_analysis_required'].to_s)
            new_value.gsub!('#{wordings[strand_short]}', data["strands"][strand.to_s].to_s)
            new_value.gsub!('#{descriptive_term[strand]}', data["wordings"][strand.to_s].to_s)
            new_value.gsub!('#{non-religious clause if strand == "faith"}', strand.to_s == "faith" ? ' - as well as those who do not have a religion or belief' : '')
            new_value.gsub!('#{"different " if strand == "gender"}', strand.to_s == "gender" ? 'different' : '')
            new_value.gsub!('#{sentence_desc(strand)}', sentence_desc(strand.to_s))
            if data["extra_strand_wordings"][section.to_s] && data["extra_strand_wordings"][section.to_s][question_number]
              new_value.gsub!("\#{data[\"extra_strand_wordings\"][\"#{section}\"][#{question_number}][strand]}", data["extra_strand_wordings"][section.to_s][question_number][strand.to_s].to_s)
              new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_word"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_word'][strand.to_s].to_s)
              new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_paragraph"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_paragraph'][strand.to_s].to_s)
            end
            texts[key] = new_value
          end
          basic_attributes = {:input_type => question_data["type"], :needed => question_data["dependent_questions"].blank?,
                               :help_text => texts[:help_text], :label => texts[:label], :name => "#{section}_#{strand}_#{question_number}",
                               :strand => strand, :section => section}
          basic_attributes[:choices] = data['choices'][question_data['choices']] if question_data['choices']
          question = self.questions.build(basic_attributes)
          question.save!
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
        begin
          self.questions.find_by(name: parent_q).dependencies.create!(:child_question => child, :required_value => value)
        rescue
          raise parent_q.inspect
        end
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
    true
  end

  def show_full_assessment?
    true
  end

  #broken with section and strand passed!
  def started(section = nil, strand = nil)
    like = [section, strand].join('\_')
    # Find all incomplete questions with the given arguments
    args = {:completed => true}
    args[:section] = section if section
    args[:strand] = strand if strand
    answered_questions = self.questions.where(args)
    return true if answered_questions.size > 0
    if section && !(section == :action_planning) then
       #First we calculate all the questions, in case there is a nil.
        answered_questions = []
        answered_questions += self.questions.where( "name LIKE 'consultation_%#{strand}_7' and completed = true")
        # answered_questions += self.questions.where( "name LIKE 'impact_%#{strand}_9' and completed = true")
        return true if answered_questions.size > 0
    end
    if section && !(section == :purpose) then #Check strategies are completed.
      self.activity_strategies.each do |strategy|
        if check_response(strategy.strategy_response) then
          return true
        end
      end
    end
    return false
  end

  def overall_relevant?
    true
  end

  def overall_relevant
    true
  end

  def relevant_action_count
    actions = 0
    strands.each do |relevant_strand|
      # actions += self.issues.where(:section => "impact", :strand => relevant_strand).count if self.questions.find_by(name: "impact_#{relevant_strand}_9").raw_answer == "1"
      actions += self.issues.where(:section => "consultation", :strand => relevant_strand).count if self.questions.find_by(name: "consultation_#{relevant_strand}_7").raw_answer == "1"
    end
    actions += self.issues.where(:section => "action_planning").count
    actions += self.issues.where(:section => nil).count
    actions
  end


  def disabled_strands
    self.strands(true) - self.strands
  end

  def action_plan_completed
    issues_to_check = []
    strands(false).each do |enabled_strand|
      # impact_qn = "impact_#{enabled_strand}_9"
      consultation_qn = "consultation_#{enabled_strand}_7"
      # impact_answer = self.questions.where(:name => impact_qn).first.response.to_i
      consultation_answer = self.questions.where(:name => consultation_qn).first.response.to_i
      impact_needed = true
      consultation_needed = true
      # if impact_answer == 1  && impact_needed then
      #   issues = self.issues_by('impact', enabled_strand)
      #   return "No" if issues.size == 0
      #   issues_to_check << issues
      # end
      if consultation_answer == 1 && consultation_needed then
        issues = self.issues_by('consultation', enabled_strand)
        return "No" if issues.size == 0
        issues_to_check << issues
      end
    end
    #check the issues are correct from their presence earlier
    return "Not applicable" if issues_to_check.length == 0
    issues_to_check.flatten.each{|issue| return "No" unless issue.check_responses}
    return "Yes"
  end

  #This allows you to check whether a activity, section or strand has been completed.
  #TODO: Is this the best way to check completion? These look like they should be split into seperate methods for clarity.
  def completed(section = nil, strand = nil)
    is_purpose = (section.to_s == 'purpose')
    #are all the strategies completed if they need to be?
    strategies_not_completed = self.activity_strategies.where('strategy_response LIKE 0').size > 0
    return false if strategies_not_completed && (is_purpose || section.nil?)
    #Special check for the unique conditions where section and strand are nil
    if section.nil? && strand.nil? then
      search_conditions = {:completed => false, :needed => true}
      question_set = self.questions.where(search_conditions)
      self.disabled_strands.each do |s|
        question_set = question_set.where.not( strand: s )
      end
      return false if question_set.size > 0
    end
    #Are there any questions which are required and not completed?
    search_conditions = {:completed => false, :needed => true}
    search_conditions[:section] = section.to_s if section
    strand_list = is_purpose ? strands(true).push("overall") : strands(true)
    strand_list.each do |s|
      unless is_purpose
        if strand
          next if strand.to_s != s.to_s
        else
          next if !self.send("#{s}_relevant")
        end
      end
      # if section.to_s == "consultation" || section.blank?
      #   consultation_qns = self.questions.where(:name => ["consultation_#{s.to_s}_1", "consultation_#{s.to_s}_4"])
      #   return false if consultation_qns.inject(true){|t,q| t && q.raw_answer == "2"}
      # end
      search_conditions[:strand] = s.to_s
      results = self.questions.where(search_conditions)
      if section.to_s == "purpose"
        results = results.where.not(name: "purpose_overall_14")
      end
      return false if results.size > 0
    end
    #check if we need to check issues?
    issues_to_check = []

    strands(!strand.to_s.blank?).each do |enabled_strand|
      next unless enabled_strand.to_s.include? strand.to_s
      # impact_qn = "impact_#{enabled_strand}_10"
      consultation_qn = "consultation_#{enabled_strand}_7"
      # impact_answer = self.questions.where(:name => impact_qn).first.response.to_i
      consultation_answer = self.questions.where(:name => consultation_qn).first.response.to_i
      # impact_needed = (section.to_s == 'impact' || section.to_s == 'action_planning' || section.nil?)
      consultation_needed = (section.to_s == 'consultation' || section.to_s == 'action_planning'  || section.nil?)

      # if impact_answer == 1  && impact_needed then
      #   issues = self.issues_by('impact', enabled_strand)
      #   return false if issues.size == 0
      #   issues_to_check << issues
      # end

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

  # def issues_relevant?(strand)
  #   impact_qn = "impact_#{strand}_9"
  #   consultation_qn = "consultation_#{strand}_7"
  #   impact_answer = self.questions.where(:name => impact_qn).first.response.to_i
  #   consultation_answer = self.questions.where(:name => consultation_qn).first.response.to_i

  #   if impact_answer==1 || consultation_answer==1
  #     issues.find_by(strand: strand.to_s)
  #   else
  #     false
  #   end


  #   # issues_to_check = []
  #   # if impact_answer == 1
  #   #   issues = self.issues_by('impact', strand)
  #   #   return false if issues.size == 0
  #   #   issues_to_check << issues
  #   # end
  #   # if consultation_answer == 1
  #   #   issues = self.issues_by('consultation', strand)
  #   #   return false if issues.size == 0
  #   #   issues_to_check << issues
  #   # end
  #   # issues_to_check.empty?
  # end

  def activity_and_questions_updated_between(start_date, end_date)
    return false unless self.updated_on
    return true unless start_date && end_date
    activity_between = self.updated_on > start_date && self.updated_on < end_date
    questions_between = self.questions.where( "updated_at between ? and ?", start_date, end_date ).size > 0
    questions_after = self.questions.where( "updated_at between ? and ?", end_date, Time.now ).size > 0
    return (activity_between || questions_between) && !questions_after
  end

  def target_and_strategies_completed
    answered_questions = self.questions.where(:name => ["purpose_overall_2"]).where("completed = true OR needed = false")
    return false unless answered_questions.size == 1
    self.activity_strategies.each do |strategy|
      unless check_response(strategy.strategy_response) then
        return false
      end
    end
    return true
  end

  def impact_on_individuals_completed
    answered_questions = self.questions.where("name REGEXP 'purpose\_overall\_(5|6|7)' AND (completed = true OR needed = false)")
    return false unless answered_questions.flatten.size == 3
    return true
  end

  def impact_on_equality_groups
    answered_questions = []
    self.strands(true).each do |strand|
      answered_questions += self.questions.where("name REGEXP 'purpose\_#{strand.to_s}\_(3|4)' AND (completed = true OR needed = false)")
    end
    return false unless answered_questions.flatten.size == 18
    return true
  end

  def issues_by(section = nil, strand = nil)
    conditions = {}
    conditions[:section] = section.to_s if section
    conditions[:strand] = strand.to_s if strand
    self.issues.where(conditions)
  end

  def strand_relevancies
    list = {}
    hashes['wordings'].keys.each do |strand|
      list["#{strand}_relevant".to_sym] = send("#{strand}_relevant".to_sym)
    end
    list
  end

  def update_completed
    sections.each do |section|
      self.send("#{section}_completed=".to_sym, true)
      strands.each do |strand|
        self.send("#{section}_completed=".to_sym, self.send("#{section}_completed".to_sym) && completed(section.to_s, strand.to_s))
      end
    end
    strands.each do |strand|
      self.send("#{strand}_relevant=".to_sym, self.questions.where(:name => "purpose_#{strand.to_s}_4").first.raw_answer == "1")
    end
    true
  end

  def sections
    self.class.sections
  end

  def self.sections
    [:purpose, :impact, :consultation, :action_planning, :additional_work]
  end

  def overview_strands
    {'gender' => 'gender', 'race' => 'race', 'disability' => 'disability', 'faith' => 'faith', 'sex' => 'sexual_orientation', 'age' => 'age', 'gender_reassignment' => 'gender_reassignment', 'pregnancy_and_maternity' => 'pregnancy_and_maternity', 'marriage_civil_partnership' => 'marriage_civil_partnership'}
  end

  def strand_required?(strand)
    q  = self.questions.where(:name => "purpose_#{strand.to_s}_4")
    return false unless q.first
    q.first.response == 1
  end

  def strand_relevant?(strand)
    self.send("#{strand.to_s}_relevant")
  end

  def update_relevancies!
    strand_attributes = {}
    self.strands(true).each do |strand|
      if self.questions.where(:name => "purpose_#{strand.to_s}_4").first.raw_answer == "1"
        strand_attributes["#{strand}_relevant"] =  true
      else
        strand_attributes["#{strand}_relevant"] = false
      end
    end
    self.update_attributes!(strand_attributes)
  end

  def strands(return_all = false)
    return self.class.strands if return_all
    strand_list = ['gender', 'race', 'disability', 'faith', 'sexual_orientation', 'age', 'gender_reassignment', 'pregnancy_and_maternity', 'marriage_civil_partnership'].map{|strand| strand if self.send("#{strand}_relevant") || self.strand_required?(strand)}
    strand_list.compact
  end

  def self.strands
    ['gender', 'race', 'disability', 'faith', 'sexual_orientation', 'age', 'gender_reassignment', 'pregnancy_and_maternity', 'marriage_civil_partnership']
  end

  def activity_type_name
    self.types[self.activity_type.to_i].to_s
  end

  def activity_status_name
    self.statuses[self.activity_status.to_i].to_s
  end

  def types
    # ["policy", "function", "strategy", "service"]
    ["policy", "function"]
  end

  def proposed?
    self.activity_status == 2
  end

  def existing?
    self.activity_status == 1
  end

  def statuses
    ["New/Proposed", "Reviewed", "Amended"]
  end

  def activity_relevant?
    self.strands.size > 0
  end

  def clone
    new_activity = Activity.create!(self.attributes)
    self.questions.each do |q|
      next unless new_q = new_activity.questions.find_by(name: q.name)
      new_q.completed = q.completed
      new_q.needed = q.needed
      new_q.raw_answer = q.raw_answer
      new_q.build_note(:contents => q.note.contents) if q.note
      new_q.build_comment(:contents => q.comment.contents) if q.comment
      new_q.save!
    end
    self.activity_strategies.each do |a|
      new_a = new_activity.activity_strategies.build(:strategy_id => a.strategy_id, :strategy_response => a.strategy_response)
      new_a.save!
    end
    self.issues.each do |i|
      new_i= new_activity.issues.build(:description => i.description, :actions => i.actions, :timescales => i.timescales, :completing => i.completing, :recommendations => i.recommendations, :monitoring => i.monitoring,
                                      :outcomes => i.outcomes, :resources => i.resources, :lead_officer => i.lead_officer, :strand => i.strand, :section => i.section, :parent_issue_id => i.id)
      new_i.save!
    end
    new_activity.ready = false
    new_activity.approved = false
    new_activity.submitted = false
    new_activity.undergone_qc = false
    new_activity.review_on = nil
    new_activity.save
    new_activity
  end

  def self.question_setup_names
    {:purpose =>          { :overall => [2,5,6,7, 13,14],
                            :race => [3,4],
                            :disability => [3,4],
                            :sexual_orientation => [3,4],
                            :gender => [3,4],
                            :gender_reassignment => [3,4],
                            :pregnancy_and_maternity => [3,4],
                            :marriage_civil_partnership => [3,4],
                            :faith => [3,4],
                            :age => [3,4]
                          },
      :impact =>          { :race => [1,2,3,4,5,8,10],
                            :disability => [1,2,3,4,5,8,10],
                            :sexual_orientation => [1,2,3,4,5,8,10],
                            :gender => [1,2,3,4,5,8,10],
                            :gender_reassignment => [1,2,3,4,5,8,10],
                            :pregnancy_and_maternity => [1,2,3,4,5,8,10],
                            :marriage_civil_partnership => [1,2,3,4,5,8,10],
                            :faith => [1,2,3,4,5,8,10],
                            :age => [1,2,3,4,5,8,10]
                          },
      :consultation =>    { :race => [1,2,3,4,5,6,7],
                            :disability => [1,2,3,4,5,6,7],
                            :sexual_orientation => [1,2,3,4,5,6,7],
                            :gender => [1,2,3,4,5,6,7],
                            :gender_reassignment => [1,2,3,4,5,6,7],
                            :pregnancy_and_maternity => [1,2,3,4,5,6,7],
                            :marriage_civil_partnership => [1,2,3,4,5,6,7],
                            :faith => [1,2,3,4,5,6,7],
                            :age => [1,2,3,4,5,6,7]
                          },
      :additional_work => { :race => [1,2,4,6, 10, 11],
                            :disability => [1,2,4,6,7,8,9, 10, 11],
                            :sexual_orientation => [1,2,4,6, 10, 11],
                            :gender => [1,2,4, 10],
                            :gender_reassignment => [1,2,4,6, 10, 11],
                            :pregnancy_and_maternity => [1,2,4,6, 10, 11],
                            :marriage_civil_partnership => [1,2,4,6, 10, 11],
                            :faith => [1,2,4,6, 10, 11],
                            :age => [1,2,4,6, 10, 11]
                          }
    }
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
