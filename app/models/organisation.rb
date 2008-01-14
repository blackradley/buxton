#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
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
  belongs_to :organisation_manager, :dependent => :destroy
  has_many :directorates, :dependent => :destroy
  has_many :strategies, :dependent => :destroy
  has_many :activities, :through => :directorates

  validates_presence_of :organisation_manager
  validates_associated :organisation_manager
  validates_associated :directorates
  validates_associated :strategies
  validates_presence_of :name, :message => 'All organisations must have a name'
  validates_presence_of :style, :message => 'Please provide an css style name, all organisations must have a style'
  validates_format_of :style, :with => /^[\w]*$/
  # validates_uniqueness_of :style

  after_update :save_directorates

  def strategy_text
    button_selected = self.strategy_text_selection
    button_selected = 0 unless button_selected
    case button_selected
      when 0
        return "How do you contribute to our goals?"
      when 1
        return "For each strategy, please decide whether it is going to be significantly aided by the function"
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
      section_data << self.activities.inject(0) { |started, activity| started += (activity.started(section.to_sym)) ? 1 : 0 }
      section_data << self.activities.inject(0) { |completed, activity| completed += (activity.completed(section.to_sym)) ? 1 : 0 }
      table << [section, section_data.to_a]
    end
    return table
  end

  def activity_summary_table
    results_table = { 1 => { :high => 0, :medium => 0, :low => 0 },
                      2 => { :high => 0, :medium => 0, :low => 0 },
                      3 => { :high => 0, :medium => 0, :low => 0 },
                      4 => { :high => 0, :medium => 0, :low => 0 },
                      5 => { :high => 0, :medium => 0, :low => 0 } }

    # Loop through all the activities this organisation has, generate statistics for
    # the completed ones and fill in the results table accordingly.
    for activity in self.activities
      if activity.completed then
        begin
	results_table[activity.priority_ranking][activity.impact_wording] += 1
	rescue
	end
      end
    end
    return results_table
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
    summary_table = self.activity_summary_table.to_a
    summary_table.sort!
    data << summary_table
    data << self.directorates
    data << full_report
  end

  def directorate_attributes=(directorate_attributes)
    directorate_attributes.each do |attributes|
      if attributes[:id].blank?
        directorates.build(attributes)
      else
        directorate = directorates.detect { |d| d.id == attributes[:id].to_i }
        directorate.attributes = attributes
      end
    end
  end

  def save_directorates
    directorates.each do |d|
      if d.should_destroy?
        d.destroy
      else
        d.save(false)
      end
    end
  end

  def directorate_string
    if self.directorate_term and !self.directorate_term.blank? then
      self.directorate_term.capitalize
    else
      "Directorate"
    end
  end

end
