require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase
  subject{ Factory(:activity)}
  
  should validate_presence_of(:name).with_message(/All activities must have a name/)
  should validate_presence_of(:completer)
  should validate_presence_of(:approver)
  should validate_presence_of(:service_area)
  # should validate_uniqueness_of(:ref_no).with_message('Reference number must be unique')
  
  context "when an activity is brand new" do
    setup do
      @service_area = Factory(:service_area)
      @completer = Factory(:user)
      @approver = Factory(:user)
      @activity = Factory(:activity, :completer => @completer, :approver => @approver, :service_area => @service_area)
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
      assert !@activity.questions.find_by_name('purpose_overall_13').completed?
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
      @service_area = Factory(:service_area)
      @completer = Factory(:user)
      @approver = Factory(:user)
      @activity = Factory(:activity, :completer => @completer, :approver => @approver, :service_area => @service_area)
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
      assert !@activity.questions.find_by_name('purpose_overall_13').completed?
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
end
