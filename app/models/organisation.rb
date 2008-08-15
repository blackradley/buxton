#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
# Each organisation is owned by a single user. It is entirely possible that more
# than one user will want to edit the organisation or at least review the status
# of a Function.  The named user (identified by the email) could then pass the
# "unique" URL on to anyone to mess about with.  Let's face it users tend to
# hand out their passwords to anyone so you might as well accept the fact and
# live with it.
#
# Like the function there has to be a valid User before you can create an organisation.
# The organisation has strategies (or priorities, call them what you will) which
# each of the functions will have to subscribe to. This isn't really a many to many
# relationship, though I first sight I thought it was.
#
# So that the users of each organisation can get a differently styled version of
# the application, each organisation has it's own style sheet.  The plan is to name
# each of the style sheets after the local authority, so the style sheet for
# www.birmingham.gov.uk will be birmingham.css. The style sheets will have to be
# hand crafted when each of the local authorities joins to become an organisation
# in the system.
#
class Organisation < ActiveRecord::Base
  has_many :organisation_managers, :dependent => :destroy
  has_many :directorates, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :organisation_strategies, :dependent => :destroy
  has_many :activities, :through => :directorates
  has_many :organisation_terminologies, :dependent => :destroy
  has_one :activity_creator, :dependent => :destroy


  validates_presence_of :organisation_managers
  validates_associated :organisation_terminologies
  validates_associated :organisation_strategies
  validates_presence_of :name, :message => 'All organisations must have a name'
  
  after_update :save_organisation_managers
  after_update :save_organisation_strategies

  def strategy_text
    button_selected = self.strategy_text_selection
    button_selected = 0 unless button_selected
    case button_selected
      when 0
        return "How do you contribute to our goals?"
      when 1
        return "For each #{self.term('strategy')}, please decide whether it is going to be significantly aided by the function"
    end
  end

  def hashes
    @@Hashes
  end

  def progress_table
    table = []
    section_names = self.hashes['section_names']
    section_names.each do |section|
      section_data = []
      section_data << self.activities.inject(0) { |started, activity| started += (activity.started(section.to_sym)) ? 1 : 0;}
      section_data << self.activities.inject(0) { |completed, activity| completed += (activity.completed(section.to_sym)) ? 1 : 0 }
      table << [section, section_data.to_a]
    end
    return table
  end

  def Organisation.results_table(org)
    results_table = { 1 => { :high => 0, :medium => 0, :low => 0 },
                      2 => { :high => 0, :medium => 0, :low => 0 },
                      3 => { :high => 0, :medium => 0, :low => 0 },
                      4 => { :high => 0, :medium => 0, :low => 0 },
                      5 => { :high => 0, :medium => 0, :low => 0 } }

    # Loop through all the activities this organisation has, generate statistics for
    # the completed ones and fill in the results table accordingly.
    for activity in org.activities
      if activity.approved == 'approved' then
        begin
  results_table[activity.priority_ranking][activity.impact_wording] += 1
  rescue
  end
      end
    end
    return results_table
  end

  def results_table
    Organisation.results_table(self)
  end

  def generate_pdf_data(full_report = false)
    data = [self.name, 0,0,0,0,0]
    self.activities.each do |activity|
      case activity.function_policy
        when 0
          data[5] += 1
        when 1
          case activity.existing_proposed
            when 0
              data[5] += 1
            when 1
              data[1] += 1
            when 2
              data[2] += 1
          end
        when 2
          case activity.existing_proposed
            when 0
              data[5] += 1
            when 1
              data[3] += 1
            when 2
              data[4] += 1
          end
       end
    end
    data << self.activities.length
    data << self.progress_table
    results_table = self.activity_results_table.to_a
    results_table.sort!
    data << results_table
    data << self.directorates
    data << full_report
  end

  def organisation_strategy_attributes=(organisation_strategy_attributes)
    organisation_strategy_attributes.each do |attributes|
      next if attributes[:name].blank?
      if attributes[:id].blank?
        organisation_strategies.build(attributes)
      else
        organisation_strategy = organisation_strategies.detect { |d| d.id == attributes[:id].to_i }
        attributes.delete(:id)
        organisation_strategy.attributes = attributes
      end
    end
  end

  def save_organisation_strategies
    self.organisation_strategies.each do |os|
      if os.should_destroy?
        os.destroy
      else
        os.save(false)
      end
    end
  end

  def organisation_manager_attributes=(organisation_manager_attributes)
    organisation_manager_attributes.each do |attributes|
      next if attributes[:email].blank?
      if attributes[:id].blank?
        organisation_managers.build(attributes)
      else
        organisation_manager = organisation_managers.detect{ |om| om.id == attributes[:id].to_i }
        attributes.delete(:id)
        organisation_manager.attributes = attributes
      end
    end
  end

  def save_organisation_managers
    organisation_managers.each do |om|
      if om.should_destroy?
        om.destroy
      else
        om.save(false)
      end
    end
  end
  
  def term(term)
    assoc_term = Terminology.find_by_term(term)
    terminology = self.organisation_terminologies.find_by_terminology_id(assoc_term.id)
    terminology ? terminology.value : term
  end

end
