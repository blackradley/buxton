#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class Generate
  # def self.event(options={})
  #   attendees = options.delete(:attendees) || []
  #   event = Event.create!(options.reverse_merge(:name => “sample event name”, :private => false))
  #   attendees.each do |attendee|
  #     Generate.rsvp(:event => event, :user => attendee)
  #   end
  #   event
  # end
  
  # Activities
  def self.activity(options={})
    Activity.new(options.reverse_merge(:email => random_email)).save!
  end
  
  def self.ces_activity(options={})
    Activity.new(options.reverse_merge(ces_activity_attributes)).save!
  end
  
  def self.stage1_activity(options={})
    Activity.new(options.reverse_merge(stage1_activity_attributes)).save!
  end  

  def self.stage2a_activity(options={})
    Activity.new(options.reverse_merge(stage2a_activity_attributes)).save!
  end
  
  def self.stage2b_activity(options={})
    Activity.new(options.reverse_merge(stage2b_activity_attributes)).save!
  end
  
  def self.stage2c_activity(options={})
    Activity.new(options.reverse_merge(stage2c_activity_attributes)).save!
  end    
  
  def self.stage2_activity(options={})
    Activity.new(options.reverse_merge(stage2_activity_attributes)).save!
  end
  
  def self.submitted_activity(options={})
    Activity.new(options.reverse_merge(submitted_activity_attributes)).save!
  end
  
  def self.approved_activity(options={})
    Activity.new(options.reverse_merge(approved_activity_attributes)).save!
  end  
  
  # Users
  def self.activity_manager(options={})
    ActivityManager.create!(options.reverse_merge(:email => random_email))
  end  
  def self.activity_approver(options={})
    ActivityApprover.create!(options.reverse_merge(:email => random_email))
  end

private

  # Attributes
  def self.activity_attributes
    {
      :name => random_string,
      :activity_manager => self.activity_manager,
      :activity_approver => self.activity_approver,      
    }
  end
  
  def self.ces_activity_attributes
    {
      :ces_question => 1, # Yes
    }.reverse_merge(self.activity_attributes)
  end
  
  def self.stage1_activity_attributes
    {
      :function_policy => 1, # Function
      :existing_proposed => 1, # Existing
    }.reverse_merge(self.ces_activity_attributes)
  end
  
  def self.stage2a_activity_attributes
    {
      # What is the target outcome of the Function?
      :purpose_overall_2 => random_string,
      # Is the Function delivered by a third party?
      :purpose_overall_11 => 3, # Not Sure
      # TODO: Loop through Organisation, Directorate, and Project strategies to complete this section      
    }.reverse_merge(self.stage1_activity_attributes)
  end

  def self.stage2b_activity_attributes  
    {
      # Which of these individuals does the Function have an impact on?
      # Service users
      :purpose_overall_5 => 3, # Not Sure
      # Staff employed by the organisation
      :purpose_overall_6 => 3, # Not Sure
      # Staff of supplier organisations
      :purpose_overall_7 => 3, # Not Sure
      # Staff of partner organisations
      :purpose_overall_8 => 3, # Not Sure
      # Employees of businesses
      :purpose_overall_9 => 3, # Not Sure      
    }.reverse_merge(self.stage2a_activity_attributes)
  end
  
  def self.stage2c_activity_attributes  
    {
      # If the Function is operating effectively might it have the potential to
      # positively impact members of the following groups differently?
      # Men and women
      :purpose_gender_3 => 1, # None at all
      # Individuals from different ethnic backgrounds
      :purpose_race_3 => 1, # None at all
      # Individuals with different kinds of disability
      :purpose_disability_3 => 1, # None at all
      # Individuals of different faiths
      :purpose_faith_3 => 1, # None at all
      # Individuals of different sexual orientations
      :purpose_sexual_orientation_3 => 1, # None at all
      # Individuals of different ages
      :purpose_age_3 => 1, # None at all
      # If the Function is not operating effectively might it have the potential to
      # negatively impact members of the following groups differently?
      # Men and women
      :purpose_gender_4 => 1, # None at all
      # Individuals from different ethnic backgrounds
      :purpose_race_4 => 1, # None at all
      # Individuals with different kinds of disability
      :purpose_disability_4 => 1, # None at all
      # Individuals of different faiths
      :purpose_faith_4 => 1, # None at all
      # Individuals of different sexual orientations
      :purpose_sexual_orientation_4 => 1, # None at all
      # Individuals of different ages
      :purpose_age_4 => 1, # None at all
    }.reverse_merge(self.stage2b_activity_attributes)
  end
  
  def self.stage2_activity_attributes
    self.stage2c_activity_attributes
  end
  
  def self.submitted_activity_attributes
    {
      :approved => "submitted"
    }.reverse_merge(self.stage2_activity_attributes)
  end
  
  def self.approved_activity_attributes
    {
      :approved => "approved"
    }.reverse_merge(self.submitted_activity_attributes)
  end

  # Helpers
  
  def self.random_email
    # example.com/net/org are official domain names to use for examples and should bounce
    # http://en.wikipedia.org/wiki/Example.com
    "#{random_string}@example.org"
  end
  
  def self.random_string
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    Array.new(10){||chars[rand(chars.size)]}.join('')
  end

end