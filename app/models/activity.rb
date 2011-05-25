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
  
  validates :name, :presence => {:if => :ready?, :full_message => 'Your EA must have a name'}
  validates :approver, :presence => {:if => :ready?, :full_message =>"Your EA has to have a Senior Officer"}
  validates :completer, :presence => {:if => :ready?, :full_message =>"Your EA has to have a Task Group Manager"}
  validates :start_date, :presence => {:if => :ready?, :full_message =>"You must enter the date the EA will start"}
  validates :end_date, :presence => {:if => :ready?, :full_message =>"You must enter the date the EA will finish on"}
  validates :review_on, :presence => {:if => :ready?, :full_message =>"You must enter the review date for your EA"}
  # validates_presence_of :name, :message => 'All activities must have a name.'
  validates_uniqueness_of :ref_no, :message => 'Reference number must be unique', :if => :ref_no?
  # validates_presence_of :completer, :approver
  # validates_presence_of :service_area
  validates_associated :completer, :approver
#  validates_associated :questions
  # validates_uniqueness_of :name, :scope => :directorate_id
  
  before_update :set_approved, :update_completed
  after_create :create_questions_if_new
  
  include FixInvalidChars
  
  before_save :fix_fields
  
  scope :ready, {:conditions => {:ready => true}}
  
  accepts_nested_attributes_for :questions, :issues
  
  
  def fields_complete
    return false if self.name.blank?
    return false if self.approver.blank?
    return false if self.completer.blank?
    return false if self.start_date.blank?
    return false if self.end_date.blank?
    return false if self.review_on.blank?
    return true
  end
  
  def progress
    if !self.ready
      return "PC"
    end
    if self.approved
      return "A"
    end
    unless self.started
      return "NS"
    end
    if self.questions.where("completed = true AND (section != 'purpose' OR name = 'purpose_overall_14') ").size > 0
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
  
  def directorate
    self.service_area ? self.service_area.directorate : nil
  end
  
  def directorate_id
    self.service_area ? self.service_area.directorate.id : nil
  end
  
  def directorate=(id)
  end
  
  def creator
    self.service_area.directorate.creator
  end
  
  def approver_email
    if self.approver
      self.approver.email
    else
      ""
    end
  end
  
  def approver_email=(email)
    if user = User.live.find_by_email(email)
      self.approver_id = user.id
    end
  end
  
  def completer_email
    if self.completer
      self.completer.email
    else
      ""
    end
  end
  
  def completer_email=(email)
    if user = User.live.find_by_email(email)
      self.completer_id = user.id
    end
  end
  
  def fix_fields
    self.attributes.each_pair do |key, value|
      self.attributes[key] = fix_field(value)
    end
  end
  
  ## One statement per question is far too slow
  ## Execute SQL directly for a single INSERT statement, using SELECT and JOIN.
  ## See http://blog.sqlauthority.com/2007/06/08/sql-server-insert-multiple-records-using-one-insert-statement-use-of-union-all/
  def create_questions_if_new
    # Initialise a question, for every question name, if this is a new record
    # 
    # 
    # 
    return true unless self.questions.blank?
    data = File.open(Rails.root + "config/questions.yml"){|yf| YAML::load( yf ) }
    dependents = {}
    Activity.question_setup_names.each do |section, strand_list|
      strand_list.each do |strand, question_list|
        question_list.each do |question_number|
          question_data = strand.to_s == "overall" ? data["overall_questions"]['purpose'][question_number] : data["questions"][section.to_s][question_number]
          old_texts = {:label => question_data['label'].dup, :help_text => question_data["help"].dup}
          texts = {}
          old_texts.each do |key, value|
            #some questions have extra wordings on a per section and strand basis. The exceptions for this are codified here
            new_value = value.to_s
            new_value.gsub!('#{wordings[strand]}', data["wordings"][strand.to_s].to_s)
            new_value.gsub!('#{descriptive_term[strand]}', data["wordings"][strand.to_s].to_s)
            new_value.gsub!('#{"different " if strand == "gender"}', strand.to_s == "gender" ? 'different' : '')
            new_value.gsub!('#{sentence_desc(strand)}', sentence_desc(strand.to_s))
            if data["extra_strand_wordings"][section.to_s] && data["extra_strand_wordings"][section.to_s][question_number]
              new_value.gsub!("\#{data[\"extra_strand_wordings\"][\"#{section}\"][#{question_number}][strand]}", data["extra_strand_wordings"][section.to_s][question_number][strand.to_s].to_s)
              new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_word"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_word'][strand.to_s].to_s)
              new_value.gsub!('#{data["extra_strand_wordings"]["impact"][6]["extra_paragraph"][strand]}', data["extra_strand_wordings"]['impact'][6]['extra_paragraph'][strand.to_s].to_s)
            end
            begin
              raise section.to_s+strand.to_s+question_number.to_s+new_value.inspect if new_value.include?("\#{")
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
          self.questions.find_by_name(parent_q).dependencies.create!(:child_question => child, :required_value => value)
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
        answered_questions += self.questions.find(:all, :conditions => "name LIKE 'consultation_%#{strand}_7' and completed = true")
        answered_questions += self.questions.find(:all, :conditions => "name LIKE 'impact_%#{strand}_9' and completed = true")
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
  

  def disabled_strands
    self.strands(true) - self.strands
  end
  
  #This allows you to check whether a activity, section or strand has been completed.
  def completed(section = nil, strand = nil)
    is_purpose = (section.to_s == 'purpose')
    #are all the strategies completed if they need to be?
    strategies_not_completed = self.activity_strategies.find(:all, :conditions => 'strategy_response LIKE 0').size > 0
    return false if strategies_not_completed && (is_purpose || section.nil?)
    #Special check for the unique conditions where section and strand are nil
    if section.nil? && strand.nil? then
      search_conditions = {:completed => false, :needed => true}
      question_set = self.questions.find(:all, :conditions => search_conditions)
      self.disabled_strands.each do |s|
        question_set.reject!{|q| q.strand.to_s == s.to_s}
      end
      return false if question_set.size > 0
    end
    #Are there any questions which are required and not completed?
    new_section = section.nil? ? self.sections.map(&:to_s).join("|") : section
    new_strand = strand.nil? ? self.strands(is_purpose).push("overall").join("|") : strand
    search_conditions = {:completed => false, :needed => true}
    search_conditions[:section] = section.to_s if section
    strand_list = is_purpose ? strands(true).push("overall") : strands(true)
    strand_list.each do |s|
      if strand
        next if strand.to_s != s.to_s
      else
        next if !self.send("#{s}_relevant")
      end
      search_conditions[:strand] = s.to_s
      results = self.questions.find(:all, :conditions => search_conditions)
      if section.to_s == "purpose"
        results.reject!{|q| q.name == "purpose_overall_14"}
      end
      return false if results.size > 0
    end
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
    answered_questions = self.questions.find(:all, :conditions => "name REGEXP 'purpose\_overall\_[5,6,7,8,9]' AND (completed = true OR needed = false)")
    return false unless answered_questions.flatten.size == 5
    return true
  end

  def impact_on_equality_groups
    answered_questions = []
    self.strands(true).each do |strand|
      answered_questions += self.questions.find(:all, :conditions => "name REGEXP 'purpose\_#{strand.to_s}\_3' AND (completed = true OR needed = false)")
    end
    return false unless answered_questions.flatten.size == 9
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
    q  = self.questions.where(:name => "purpose_#{strand.to_s}_3")
    return false unless q.first
    q.first.response == 1
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
  
  def clone
    parent = Activity.new(self.attributes)
    parent.ready = false
    parent.approved = false
    parent.submitted = false
    parent.start_date = nil
    parent.end_date = nil
    parent.review_on = nil
    parent.activity_strategies.select{|as| as.strategy.retired?}.map(&:destroy)
    parent.id = nil
    reflection_macro = Proc.new do |new_obj, old_obj|
      old_obj.class.reflect_on_all_associations.reject{|a| a.macro == :belongs_to}.map do |assoc|
        [assoc, new_obj, old_obj]
      end 
    end
    associations = reflection_macro.call(parent, self)
    until associations.blank? do 
      association, new_parent, old_parent = associations.shift
      case association.macro
      when :has_one
        record = old_parent.send(association.name)
        if record
          attrbs = record.attributes
          attrbs.delete('id')
          attrbs.delete(association.primary_key_name)
          new_obj = new_parent.send("#{association.name}=".to_sym, record.class.new(attrbs))         
          if new_parent.is_a?(Dependency) && record.is_a?(Question)
            new_obj = parent.questions.select{|q| q.name == record.name}.first
            new_parent.child_question = new_obj
          end
          if new_obj.respond_to? :activity_id
            new_obj.activity_id = nil
          end
          associations += reflection_macro.call(new_obj, record) 
        end
      when :has_many
        records = old_parent.send(association.name)
        records.each do |r|
          attrbs = r.attributes
          attrbs.delete('id')
          attrbs.delete(association.primary_key_name)
          new_obj = new_parent.send(association.name).build(attrbs)
          if new_obj.respond_to? :activity_id
            new_obj.activity_id = nil
          end
          associations += reflection_macro.call(new_obj, r)
        end
      end
    end
    parent
  end
  
  def self.question_setup_names
    {:purpose =>          { :overall => [2,5,6,7,8,9, 13,14],
                            :race => [3],
                            :disability => [3],
                            :sexual_orientation => [3],
                            :gender => [3],
                            :gender_reassignment => [3],
                            :pregnancy_and_maternity => [3],
                            :marriage_civil_partnership => [3],
                            :faith => [3],
                            :age => [3]
                          },
      :impact =>          { :race => [1,2,3,4,5,6,7,8,9],
                            :disability => [1,2,3,4,5,6,7,8,9],
                            :sexual_orientation => [1,2,3,4,5,6,7,8,9],
                            :gender => [1,2,3,4,5,6,7,8,9],
                            :gender_reassignment => [1,2,3,4,5,6,7,8,9],
                            :pregnancy_and_maternity => [1,2,3,4,5,6,7,8,9],
                            :marriage_civil_partnership => [1,2,3,4,5,6,7,8,9],
                            :faith => [1,2,3,4,5,6,7,8,9],
                            :age => [1,2,3,4,5,6,7,8,9]
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
      :additional_work => { :race => [1,2,3,4,6],
                            :disability => [1,2,3,4,6,7,8,9],
                            :sexual_orientation => [1,2,3,4,6],
                            :gender => [1,2,3,4],
                            :gender_reassignment => [1,2,3,4,6],
                            :pregnancy_and_maternity => [1,2,3,4,6],
                            :marriage_civil_partnership => [1,2,3,4,6],
                            :faith => [1,2,3,4,6],
                            :age => [1,2,3,4,6]
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
