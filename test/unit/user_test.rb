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
    
    should "not have the role of qc officer as a qc officer" do
      assert_equal [], @qc_officer.roles
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
      
      should "not have the qc officer as a qc officer" do
        assert_equal [], @qc_officer.roles
      end
      
    end
    

  end
end
