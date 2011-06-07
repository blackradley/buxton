#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  
  context "when a user is a creator" do
    
    setup do
      @user = Factory(:user, :creator => true)
    end
  
    should "respond to a creator method" do
      assert @user.creator?
    end
    
    should "be included in the creator scope" do
      assert User.creator.include?(@user)
    end
    
    should "not be included in the creator scope if retired" do
      @user.update_attributes(:retired => true)
      assert !User.creator.include?(@user)
    end
    
    # context "with 3 live directorates and 2 retired directorates" do
    #   setup do
    #     3.times do |i|
    #       Factory(:directorate, :creator => Factory(:user))
    #     end
    #     
    #     2.times do |i|
    #       Factory(:directorate, :creator => Factory(:user), :retired => true)
    #     end
    #   end
    #   
    #   should "have 5 directorates" do 
    #     assert_equal 5, @user.count_directorates
    #   end
    #   
    #   should "have 3 live directorates" do
    #     assert_equal 3, @user.count_live_directorates
    #   end
    # end
  end
  
  context "when a user is retired" do
    setup do
      @user = Factory(:user, :retired => true)
    end
    
    should "not be included in the live filter" do
      assert !User.live.include?(@user)
    end
      
  end
  
  context "with one activity and a completer and approver and a qc officer" do
    setup do 
      @completer = Factory(:user)
      @approver = Factory(:user)
      @qc_officer = Factory(:user)
      @normal_activity = Factory(:activity, :completer => @completer, :approver => @approver, :qc_officer => @qc_officer, :ready => true)
    end
    
    should "mark the completer as only a completer" do
      assert @completer.completer?
      assert !@completer.creator?
      assert !@completer.quality_control?
      assert !@completer.approver?
    end
  
    should "have the role of completer as a completer" do
      assert_equal ["Completer"], @completer.roles
    end
    
    should "not have the role of approver as an approver" do
      assert_equal [], @approver.roles
    end
    
    should "have the role of qc officer as a qc officer" do
      assert_equal ['Quality Control'], @qc_officer.roles
    end
    
    context "when it has been started" do
      setup do 
        @normal_activity.questions.first.update_attributes(:raw_answer => "1")
      end
    
      should "have the role of approver as an approver" do
        assert_equal ["Approver"], @approver.roles
      end
      
      should "mark the approver as only an approver" do
        assert !@approver.completer?
        assert !@approver.creator?
        assert !@approver.quality_control?
        assert @approver.approver?
      end
      
      should "have the qc officer as a qc officer" do
        assert_equal ['Quality Control'], @qc_officer.roles
      end
      
    end
    
  end
  
  context "with two activities and a completer, approver, and QC for each, and a single creator" do
    setup do
      @creator = Factory(:user, :creator => true)
      @service_area = Factory(:service_area)
      @service_area.directorate.creator = @creator
      @service_area.save!
      @completer1 = Factory(:user)
      @completer2 = Factory(:user)
      @approver1 = Factory(:user)
      @approver2 = Factory(:user)
      @qc1 = Factory(:user)
      @qc2 = Factory(:user)
      @activity1 = Factory(:activity, :service_area => @service_area, :completer => @completer1, :approver => @approver1, :qc_officer => @qc1, :ready => true, :submitted => true, :undergone_qc => false)
      @activity1.questions.first.update_attributes(:raw_answer => "1")
      @activity2 = Factory(:activity, :service_area => @service_area, :completer => @completer2, :approver => @approver2, :qc_officer => @qc2, :ready => true, :submitted => true, :undergone_qc => false)
      @activity2.questions.first.update_attributes(:raw_answer => "1")
    end
        
    should "mark both completers as completers" do
      assert @completer1.completer?
      assert @completer2.completer?
    end
    
    should "mark both approvers as approvers" do
      assert @approver1.approver?
      assert @approver2.approver?
    end
    
    should "mark both QCs as QCs" do
      assert @qc1.quality_control?
      assert @qc2.quality_control?
    end

    should "not allow completers to see the activities of other completers" do
      assert !@completer1.activities.include?(@activity2)
      assert !@completer2.activities.include?(@activity1)
    end
    
    should "not allow approvers to see the activities of other approvers" do
      assert !@approver1.activities.include?(@activity2)
      assert !@approver2.activities.include?(@activity1)
    end
    
    should "not allow qcs to see the activities of other qcs" do
      assert !@qc1.activities.include?(@activity2)
      assert !@qc2.activities.include?(@activity1)
    end
    
    should "allow the creator to see both activities" do
      #assert @creator.activities.include?(@activity1)
      #assert @creator.activities.include?(@activity2)
    end
    
  end
  
end
