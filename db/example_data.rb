module FixtureReplacement
  attributes_for :activity do |a|
    a.name = "#{String.random.titleize}"
    a.activity_manager = create_activity_manager
    a.activity_approver = create_activity_approver
	end
	
  attributes_for :ces_activity, :from => :activity do |a|
    a.ces_question = 1 # Yes
  end
  
  attributes_for :stage1_activity, :from => :ces_activity do |a|
    # This is a
    a.function_policy = 1 # Function
    # And is
    a.existing_proposed = 1 # Existing    
  end
  
  attributes_for :stage2a_activity, :from => :ces_activity do |a|
    # What is the target outcome of the Function?
    a.purpose_overall_2 = String.random
    # Is the Function delivered by a third party?
    a.purpose_overall_11 = 3 # Not Sure
    # TODO: Loop through Organisation, Directorate, and Project strategies to complete this section
  end  

  attributes_for :stage2b_activity, :from => :stage2a_activity do |a|  
    # Which of these individuals does the Function have an impact on?
    # Service users
    a.purpose_overall_5 = 3 # Not Sure
    # Staff employed by the council
    a.purpose_overall_6 = 3 # Not Sure
    # Staff of supplier organisations
    a.purpose_overall_7 = 3 # Not Sure
    # Staff of partner organisations
    a.purpose_overall_8 = 3 # Not Sure
    # Employees of businesses
    a.purpose_overall_9 = 3 # Not Sure
  end
  
  attributes_for :stage2c_activity, :from => :stage2b_activity do |a|
    # If the Function is operating effectively might it have the potential to
    # positively impact members of the following groups differently?
    # Men and women
    a.purpose_gender_3 = 3 # Not Sure
    # Individuals from different ethnic backgrounds
    a.purpose_race_3 = 3 # Not Sure
    # Individuals with different kinds of disability
    a.purpose_disability_3 = 3 # Not Sure
    # Individuals of different faiths
    a.purpose_faith_3 = 3 # Not Sure
    # Individuals of different sexual orientations
    a.purpose_sexual_orientation_3 = 3 # Not Sure
    # Individuals of different ages
    a.purpose_age_3 = 3 # Not Sure
    # If the Function is not operating effectively might it have the potential to
    # negatively impact members of the following groups differently?
    # Men and women
    a.purpose_gender_4 = 3 # Not Sure
    # Individuals from different ethnic backgrounds
    a.purpose_race_4 = 3 # Not Sure
    # Individuals with different kinds of disability
    a.purpose_disability_4 = 3 # Not Sure
    # Individuals of different faiths
    a.purpose_faith_4 = 3 # Not Sure
    # Individuals of different sexual orientations
    a.purpose_sexual_orientation_4 = 3 # Not Sure
    # Individuals of different ages
    a.purpose_age_4 = 3 # Not Sure
  end
  
  attributes_for :stage2_activity, :from => :stage2c_activity

  # Users (STI)
  attributes_for :user do |u|
  end
  
  attributes_for :activity_manager, :from => :user, :class => ActivityManager do |am|
    am.email = random_email
  end
  
  attributes_for :activity_approver, :from => :user, :class => ActivityApprover do |aa|
    aa.email = random_email
  end
  
  # Helpers
  
  def random_email
    # example.com/net/org are official domain names to use for examples and should bounce
    # http://en.wikipedia.org/wiki/Example.com
    "#{String.random}@example.org"
  end

end

