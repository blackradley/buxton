# # #  
# # # $URL$
# # # $Rev$
# # # $Author$
# # # $Date$
# # #
# # # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
# # #
require 'test_helper'
class Activities::SectionsControllerTest < ActionController::TestCase
  
  context "A completer accessing one of their activities" do
    setup do
      sign_in users(:users_003)
      @activity = activities(:activities_002)
      @activity.update_attributes(:gender_relevant => true)
      @activity.reload
    end
    
    should "be able to access section A of the initial assessment" do
      get :edit_purpose_a, :id => 2
      assert_response :success
    end
    
#    should "be able to update the answers for aection A of the initial assessment" do
#      post :update, :id => 2, :equality_strand => "overall", 
    
    should "be able to access section B of the initial assessment" do
      get :edit_purpose_b, :id => 2
      assert_response :success
    end
    
    should "be able to access section C of the initial assessment" do
      get :edit_purpose_c, :id => 2
      assert_response :success
    end
    
    should "be able to access section D of the initial assessment" do
      get :edit_purpose_d, :id => 2
      assert_response :success
    end
    
    should "be able to access the final comments section of the full assessment" do
      get :edit_full_assessment_comment, :id => 2
      assert_response :success
    end
    
    should "be able to edit the impact section of a strand" do
      get :edit, :id => 2, :equality_strand => "gender", :section => "impact"
      assert_response :success
    end
    
    should "be able to edit the consultation section of a strand" do
      get :edit, :id => 2, :equality_strand => "gender", :section => "consultation"
      assert_response :success
    end
    
    should "be able to edit the additional work section of a strand" do
      get :edit, :id => 2, :equality_strand => "gender", :section => "additional_work"
      assert_response :success
    end
    
    should "be able to edit the action planning section of a strand" do
      get :edit, :id => 2, :equality_strand => "gender", :section => "action_planning"
      assert_response :success
    end
    
    should "be able to submit updates to a strand" do
      @activity.update_attributes(:actual_start_date => "")
      post :update, :id => 2, :equality_strand => "gender", :section => "impact", :activity => {:questions_attributes => {"1" => {:raw_answer => "2", :id => "230"}, "2" => {:raw_answer => "2", :id => "231"}, "3" => {:raw_answer => "2", :id => "232"}, "4" => {:raw_answer => "2", :id => "233"}, "5" => {:raw_answer => "2", :id => "234"}, "6" => {:raw_answer => "2", :id => "235"}, "7" => {:raw_answer => "2", :id => "236"}, "8" => {:raw_answer => "2", :id => "237"}, "9" => {:raw_answer => "2", :id => "238"}}}
      assert_equal "Joes Activity 0 was successfully updated.", flash[:notice]
      Activity.find(2).questions.where(:strand => "gender", :section => "impact").each do |question|
        assert question.completed?
      end
      assert_redirected_to questions_activity_path(@activity)
    end
    
    should "not be able to submit updates to a strand if the activity is submitted" do
      @activity.update_attributes(:submitted => true)
      post :update, :id => 2, :equality_strand => "gender", :section => "impact", :activity => {:questions_attributes => {"1" => {:raw_answer => "2", :id => "230"}, "2" => {:raw_answer => "2", :id => "231"}, "3" => {:raw_answer => "2", :id => "232"}, "4" => {:raw_answer => "2", :id => "233"}, "5" => {:raw_answer => "2", :id => "234"}, "6" => {:raw_answer => "2", :id => "235"}, "7" => {:raw_answer => "2", :id => "236"}, "8" => {:raw_answer => "2", :id => "237"}, "9" => {:raw_answer => "2", :id => "238"}}}
      assert_redirected_to access_denied_path
      Activity.find(2).questions.where(:strand => "gender", :section => "impact").each do |question|
        assert !question.completed?
      end
    end
    
    should "not be able to submit updates to an invalid strand" do
      post :update, :id => 2, :equality_strand => "invalid_strand", :section => "impact", :activity => {:questions_attributes => {"1" => {:raw_answer => "2", :id => "230"}, "2" => {:raw_answer => "2", :id => "231"}, "3" => {:raw_answer => "2", :id => "232"}, "4" => {:raw_answer => "2", :id => "233"}, "5" => {:raw_answer => "2", :id => "234"}, "6" => {:raw_answer => "2", :id => "235"}, "7" => {:raw_answer => "2", :id => "236"}, "8" => {:raw_answer => "2", :id => "237"}, "9" => {:raw_answer => "2", :id => "238"}}}
      #assert_equal "Joes Activity 0 has been submitted and cannot be altered.", flash[:notice]
      Activity.find(2).questions.where(:strand => "gender", :section => "impact").each do |question|
        assert !question.completed?
      end
      assert_redirected_to access_denied_path
    end
    
#    should "be able to submit strategy updates in the purpose section"
#    post :update, :id => 2, :equality_strand => "gender", :section => "purpose",
    
  end
  
end