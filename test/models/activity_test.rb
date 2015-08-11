require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  subject{ FactoryGirl.create(:activity)}
  fixtures :activities, :questions, :users, :service_areas
  # should validate_presence_of(:name).with_message(/All activities must have a name/)
  # should validate_presence_of(:completer)
  # should validate_presence_of(:approver)
  # should validate_presence_of(:service_area)
  # should validate_uniqueness_of(:ref_no).with_message('Reference number must be unique')

  context "when creating an activity" do
    setup do
      @activity = Activity.new
      @activity.service_area_id = FactoryGirl.create(:service_area).id
    end

    should "not be able to save the activity the first time without entering any details about it" do
      assert !@activity.save
    end

    should "not be able to save the activity if required fields when ready aren't filled in" do
      @activity.name = "Sample EA"
      assert !@activity.save
    end

    should "not be able to mark the activity as ready if all required fields aren't filled in" do
      @activity.name = "Sample EA"
      @activity.ready = true
      assert !@activity.save
    end

    should "be able to mark it as ready when all required fields are filled in" do
      @activity.approver = FactoryGirl.create(:user)
      @activity.completer = FactoryGirl.create(:user)
      @activity.qc_officer = FactoryGirl.create(:user)
      @activity.review_on =Date.today
      @activity.name = "Sample ready EA"
      @activity.ready = true
      assert @activity.save
    end
  end

  context "when an activity is brand new" do
    setup do
      @activity = activities(:activities_001)
    end

    should "not be started" do
      assert !@activity.started
    end

    should "have the status of not started" do
      assert_equal "NS", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed
    end

    should "not have 1a completed" do
      assert !@activity.target_and_strategies_completed
    end

    should "not have 1b completed" do
      assert !@activity.impact_on_individuals_completed
    end

    should "not have 1c completed" do
      assert !@activity.impact_on_equality_groups
    end

    should "not have 1d completed" do
      assert !@activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    should "not have purpose completed" do
      assert !@activity.completed(:purpose)
    end

    Activity.strands.each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

  end


  context "when an activity has started the initial assessment by answering the first section" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:name => ["purpose_overall_2", "purpose_overall_11", "purpose_overall_12"]).each do |q|
        q.update_attributes(:raw_answer => "1")
      end
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the initial assessment" do
      assert_equal "IA", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "not have 1b completed" do
      assert !@activity.impact_on_individuals_completed
    end

    should "not have 1c completed" do
      assert !@activity.impact_on_equality_groups
    end

    should "not have 1d completed" do
      assert !@activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    should "not have purpose completed" do
      assert !@activity.completed(:purpose)
    end

    Activity.strands.each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

  end

  context "when an activity has started the initial assessment by answering the entire first section except part c" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:section => "purpose", :strand => "overall").select{|q| q.name != "purpose_overall_14"}.each do |q|
        q.update_attributes(:raw_answer => "1")
      end
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the initial assessment" do
      assert_equal "IA", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "have 1b completed" do
      assert @activity.impact_on_individuals_completed
    end

    should "not have 1c completed" do
      assert !@activity.impact_on_equality_groups
    end

    should "have 1d completed" do
      assert @activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    should "not have purpose completed" do
      assert !@activity.completed(:purpose)
    end

    Activity.strands.each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

  end

  context "when an activity has started the initial assessment by answering the entire first section" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:section => "purpose").select{|q| q.name != "purpose_overall_14"}.each do |q|
        q.update_attributes(:raw_answer => "1")
      end
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the initial assessment" do
      assert_equal "IA", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "have 1b completed" do
      assert @activity.impact_on_individuals_completed
    end

    should "have 1c completed" do
      assert @activity.impact_on_equality_groups
    end

    should "have 1d completed" do
      assert @activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    should "have purpose completed" do
      assert @activity.completed(:purpose)
    end

    Activity.strands.each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

  end

  context "when an activity has started the initial assessment by answering the entire first section and answered purpose overall 14" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:section => "purpose").each do |q|
        q.update_attributes(:raw_answer => "2")
      end
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the full assessment" do
      assert_equal "FA", @activity.progress
    end

    should "be completed" do
      assert @activity.completed
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "have 1b completed" do
      assert @activity.impact_on_individuals_completed
    end

    should "have 1c completed" do
      assert @activity.impact_on_equality_groups
    end

    should "have 1d completed" do
      assert @activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    should "have purpose completed" do
      assert @activity.completed(:purpose)
    end

    Activity.strands.each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

  end

  context "when an activity has started the initial assessment by answering the entire first section and started a section and strand" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:section => "purpose").each do |q|
        q.update_attributes!(:raw_answer => "2")
      end
      @activity.update_attributes(:gender_relevant => true)
      @activity.questions.where(:name => "purpose_gender_3").first.update_attributes(:raw_answer => 1)
      @activity.questions.where(:name => "purpose_gender_4").first.update_attributes(:raw_answer => 1)

      @activity.questions.where(:section => "impact", :strand => "gender").each do |q|
        q.update_attributes!(:raw_answer => "2")
      end
      @activity.questions.where(:section => "consultation", :strand => "gender").each do |q|
        q.update_attributes!(:raw_answer => "2")
      end
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the full assessment" do
      assert_equal "FA", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed(nil,nil)
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "have 1b completed" do
      assert @activity.impact_on_individuals_completed
    end

    should "have 1c completed" do
      assert @activity.impact_on_equality_groups
    end

    should "have 1d completed" do
      assert @activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    (Activity.strands - ["gender"]).each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

    should "have impact gender completed" do
      assert @activity.completed(:impact, :gender)
    end

    should "have consultation gender completed" do
      assert @activity.completed(:consultation, :gender) # No consultations are required
    end

    should "not have additional work completed" do
      assert !@activity.completed(:additional_work, :gender)
    end
  end

  context "when an activity has started the initial assessment by answering the entire first section and started a section and strand, but not filled in the issues" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:section => "purpose").each do |q|
        q.update_attributes(:raw_answer => "2")
      end
      @activity.questions.where(:name => "purpose_age_3").first.update_attributes(:raw_answer => 1)
      @activity.questions.where(:name => "purpose_age_4").first.update_attributes(:raw_answer => 1)
      @activity.update_attributes(:gender_relevant => true)

      @activity.questions.where(:section => "impact", :strand => "gender").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.questions.where(:section => "consultation", :strand => "gender").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the full assessment" do
      assert_equal "FA", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "have 1b completed" do
      assert @activity.impact_on_individuals_completed
    end

    should "have 1c completed" do
      assert @activity.impact_on_equality_groups
    end

    should "have 1d completed" do
      assert @activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    (Activity.strands - ["gender"]).each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

    should "have impact gender completed" do
      assert @activity.completed(:impact, :gender)
    end

    should "not have consultation gender completed" do
      assert !@activity.completed(:consultation, :gender)
    end

    should "not have additional work completed" do
      assert !@activity.completed(:additional_work, :gender)
    end

    should "not have action planning completed" do
      assert !@activity.completed(:action_planning, :gender)
    end

    context "when you add incomplete issues" do

      setup do
        @activity.issues.create(:strand => "gender", :section => "impact", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:strand => "gender", :section => "consultation", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
      end

      should "have impact gender completed" do
        assert @activity.completed(:impact, :gender)
      end

      should "have consultation gender completed" do
        assert @activity.completed(:consultation, :gender)
      end

      should "not have action planning completed" do
        assert !@activity.completed(:action_planning, :gender)
      end
    end

    context "when you add complete issues" do

      setup do
        @activity.issues.create(:actions => "Action", :timescales => Date.yesterday.to_s(:db), :completing => Date.tomorrow.to_s(:db), :lead_officer_id => 1, :strand => "gender", :section => "impact", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:actions => "Action", :timescales => Date.yesterday.to_s(:db), :completing => Date.tomorrow.to_s(:db), :lead_officer_id => 1, :strand => "gender", :section => "consultation", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
      end

      should "have impact gender completed" do
        assert @activity.completed(:impact, :gender)
      end

      should "have consultation gender completed" do
        assert @activity.completed(:consultation, :gender)
      end

      should "have action planning completed" do
        assert @activity.completed(:action_planning, :gender)
      end
    end


  end

  context "when an activity has started the initial assessment by answering the entire first section and completed multiple sections and strands" do
    setup do
      @activity = activities(:activities_001)
      @activity.questions.where(:section => "purpose").each do |q|
        q.update_attributes!(:raw_answer => "2")
      end
      @activity.questions.where(:name => "purpose_gender_3").first.update_attributes(:raw_answer => 1)
      @activity.questions.where(:name => "purpose_gender_4").first.update_attributes(:raw_answer => 1)

      @activity.questions.where(:name => "purpose_age_3").first.update_attributes(:raw_answer => 1)
      @activity.questions.where(:name => "purpose_age_4").first.update_attributes(:raw_answer => 1)

      @activity.update_attributes(:gender_relevant => true, :age_relevant => true)
      @activity.questions.where(:section => "impact", :strand => "gender").each do |q|
        if q.name == 'impact_gender_10'
          q.update_attributes!(:raw_answer => "2")
        else
          q.update_attributes!(:raw_answer => "1")
        end
      end
      @activity.questions.where(:section => "consultation", :strand => "gender").each do |q|
        if q.name == 'consultation_gender_7'
          q.update_attributes!(:raw_answer => "2")
        else
          q.update_attributes!(:raw_answer => "1")
        end

      end
      @activity.questions.where(:section => "additional_work", :strand => "gender").each do |q|
        q.update_attributes!(:raw_answer => "1")
      end

      @activity.questions.where(:section => "impact", :strand => "age").each do |q|
        q.update_attributes!(:raw_answer => "1")
      end
      @activity.questions.where(:section => "consultation", :strand => "age").each do |q|
        q.update_attributes!(:raw_answer => "1")
      end
      @activity.questions.where(:section => "additional_work", :strand => "age").each do |q|
        q.update_attributes!(:raw_answer => "1")
      end
      @activity
    end

    should "be started" do
      assert @activity.started
    end

    should "have the status of in the full assessment" do
      assert_equal "FA", @activity.progress
    end

    should "not be completed" do
      assert !@activity.completed
    end

    should "have 1a completed" do
      assert @activity.target_and_strategies_completed
    end

    should "have 1b completed" do
      assert @activity.impact_on_individuals_completed
    end

    should "have 1c completed" do
      assert @activity.impact_on_equality_groups
    end

    should "have 1d completed" do
      assert @activity.questions.find_by(name: 'purpose_overall_13').completed?
    end

    (Activity.strands - ["gender", "age"]).each do |strand|

      should "not have impact #{strand} completed" do
        assert !@activity.completed(:impact, strand.to_sym)
      end

      should "not have consultation #{strand} completed" do
        assert !@activity.completed(:consultation, strand.to_sym)
      end

      should "not have additional work #{strand} completed" do
        assert !@activity.completed(:additional_work, strand.to_sym)
      end

    end

    should "have impact gender completed" do
      assert @activity.completed(:impact, :gender)
    end

    should "have consultation gender completed" do
      assert @activity.completed(:consultation, :gender)
    end

    should "have gender additional work completed" do
      assert @activity.completed(:additional_work, :gender)
    end

    should "have completed gender" do
      assert @activity.completed(nil, :gender)
    end

    should "have impact age completed" do
      assert @activity.completed(:impact, :age)
    end

    should "not have consultation age completed" do
      # Final question indicates that issues need highlighting - "1" is yes, but none have been added
      assert !@activity.completed(:consultation, :age)
    end

    should "have age additional work completed" do
      assert @activity.completed(:additional_work, :age)
    end

    should "not have completed age" do
      assert !@activity.completed(nil, :age)
    end

    context "when you add incomplete issues" do

      setup do
        @activity.questions.find_by(name: 'impact_gender_9').update_attribute(:raw_answer, '1')
        @activity.questions.find_by(name: 'consultation_gender_7').update_attribute(:raw_answer, '1')
        @activity.questions.find_by(name: 'impact_age_9').update_attribute(:raw_answer, '1')
        @activity.questions.find_by(name: 'consultation_age_7').update_attribute(:raw_answer, '1')

        @activity.issues.create(:strand => "gender", :section => "impact", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:strand => "gender", :section => "consultation", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:strand => "age", :section => "impact", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:strand => "age", :section => "consultation", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
      end

      should "have impact gender completed" do
        assert @activity.completed(:impact, :gender)
      end

      should "have consultation gender completed" do
        assert @activity.completed(:consultation, :gender)
      end

      should "not have action planning completed" do
        assert !@activity.completed(:action_planning, :gender)
      end
    end

    context "when you add complete issues" do

      setup do
        @activity.questions.find_by(name: 'impact_gender_10').update_attribute(:raw_answer, '1')
        @activity.questions.find_by(name: 'consultation_gender_7').update_attribute(:raw_answer, '1')
        @activity.questions.find_by(name: 'impact_age_10').update_attribute(:raw_answer, '1')
        @activity.questions.find_by(name: 'consultation_age_7').update_attribute(:raw_answer, '1')

        @activity.issues.create(:actions => "Action", :timescales => Date.yesterday.to_s(:db), :completing => Date.tomorrow.to_s(:db), :lead_officer_id => 1, :strand => "gender", :section => "impact", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:actions => "Action", :timescales => Date.yesterday.to_s(:db), :completing => Date.tomorrow.to_s(:db), :lead_officer_id => 1, :strand => "gender", :section => "consultation", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:actions => "Action", :timescales => Date.yesterday.to_s(:db), :completing => Date.tomorrow.to_s(:db), :lead_officer_id => 1, :strand => "age", :section => "impact", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:actions => "Action", :timescales => Date.yesterday.to_s(:db), :completing => Date.tomorrow.to_s(:db), :lead_officer_id => 1, :strand => "age", :section => "consultation", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
      end

      should "have impact gender completed" do
        assert @activity.completed(:impact, :gender)
      end

      should "have consultation gender completed" do
        assert @activity.completed(:consultation, :gender)
      end

      should "have action planning gender completed" do
        assert @activity.completed(:action_planning, :gender)
      end

      should "have impact age completed" do
        assert @activity.completed(:impact, :age)
      end

      should "have consultation age completed" do
        assert @activity.completed(:consultation, :age)
      end

      should "have action planning age completed" do
        assert @activity.completed(:action_planning, :age)
      end

      should "be complete" do
        assert @activity.completed
      end
    end


  end

  context "when checking required sections" do
    setup do
      @activity = activities(:activities_001)

      @activity.questions.where(:name => "purpose_gender_3").first.update_attributes(:raw_answer => 1)
      @activity.questions.where(:name => "purpose_gender_4").first.update_attributes(:raw_answer => 1)

      @activity.questions.where(:name => "purpose_age_3").first.update_attributes(:raw_answer => 1)
      @activity.questions.where(:name => "purpose_age_4").first.update_attributes(:raw_answer => 2)

      @activity.questions.where(:name => "purpose_race_3").first.update_attributes(:raw_answer => 2)
      @activity.questions.where(:name => "purpose_race_4").first.update_attributes(:raw_answer => 1)

      @activity.questions.where(:name => "purpose_faith_3").first.update_attributes(:raw_answer => 2)
      @activity.questions.where(:name => "purpose_faith_4").first.update_attributes(:raw_answer => 2)

      @activity.update_completed
    end

    should "require section that is relevant and required" do
      assert @activity.gender_relevant
      assert @activity.strands.include?('gender')
    end


    should "not require section that is relevant but not required" do
      assert !@activity.age_relevant
      assert !@activity.strands.include?('age')
    end


    should "require section that is not relevant but is required" do
      assert @activity.race_relevant
      assert @activity.strands.include?('race')
    end

    should "not require section that neither relevant nor required" do
      assert !@activity.faith_relevant
      assert !@activity.strands.include?('faith')
    end
  end
end
