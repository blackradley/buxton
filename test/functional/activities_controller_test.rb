require 'test_helper'

class ActivitiesControllerTest < ActionController::TestCase

  fixtures :activities, :questions, :directorates, :service_areas, :users
  
  context "when logged in as an administrator" do
    setup do 
      @admin = Factory(:administrator)
      sign_in @admin
    end
    
    
    should "not be able to see any activities list" do
      [:directorate_eas, :my_eas, :approving, :directorate_governance_eas, :actions, :assisting, :quality_control].each do |activity_route|
        puts activity_route
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
  end
  
  context "when logged in as a directorate cop " do
    setup do 
      sign_in users(:users_001)
    end
    
    should "not be able to see any activities list aside from the cop ones" do
      [:directorate_eas, :my_eas, :approving, :assisting, :quality_control].each do |activity_route|
        puts activity_route
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
      
    end
    
    should "be able to see the directorate cop activities" do
      [:directorate_governance_eas, :actions].each do |activity_route|
        get activity_route
        assert_response :success
      end
    end
    
    should "be able to view the schedule file for a directorate" do
      get :generate_schedule
      assert_response :success
    end
    
    should "not be able to submit an activity for approval" do
      get :submit, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    
    should "be able to view the pdf file for an activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "be able to see an activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "be not able to see the questions" do
      get :questions, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to toggle the status of an activity" do
      post :toggle_strand, :id => activities(:activities_002).id, :strand => "gender"
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to view the creation of activity" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to accept an activity" do
      get :approve, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to reject an activity" do
      get :reject, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
  end
  
  context "when logged in as a creator" do
    setup do 
      sign_in users(:users_004)
    end
    
    should "not be able to see any activities list aside from the creator ones" do
      [:my_eas, :approving, :assisting, :quality_control].each do |activity_route|
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
    should "be able to see the creator activities" do
      get :directorate_eas
      assert_response :success
    end
    
    should "be able to see the cop activities" do
      [:directorate_governance_eas, :actions].each do |activity_route|
        get activity_route
        assert_response :success
      end
    end
    
    should "not be able to submit an activity for approval" do
      get :submit, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to view the schedule file for a directorate" do
      get :generate_schedule
      assert_response :success
    end
    
    should "be able to view the pdf file for an activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "be able to see an activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "be not able to see the questions" do
      get :questions, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to toggle the status of an activity" do
      post :toggle_strand, :id => activities(:activities_002).id, :strand => "gender"
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to view the creation of activity" do
      get :new
      assert_response :success
    end
    
    should "not be able to accept an activity" do
      get :approve, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to reject an activity" do
      get :reject, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
  end
    
    
  context "when logged in as a completer" do
    setup do 
      sign_in users(:users_003)
    end
    
    should "not be able to see any activities list aside from the completer one" do
      [:directorate_governance_eas, :directorate_eas, :approving, :actions, :assisting, :quality_control].each do |activity_route|
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
    should "be able to submit an activity for approval" do
      get :submit, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to questions_activity_path(activities(:activities_002))
    end
    
    
    should "be able to see your completer activities" do
      get :my_eas
      assert_response :success
    end
    
    should "not be able to view the schedule file for a directorate" do
      get :generate_schedule
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to view the pdf file for an activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to see an activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to see the questions" do
      get :questions, :id => activities(:activities_002).id
      assert_response :success
    end
    
    # should "be able to toggle the status of an activity" do
    #   post :toggle_strand, :id => activities(:activities_002).id, :strand => "gender"
    #   assert_response :success
    # end
    
    should "not be able to view the creation of activity" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    
    should "not be able to accept an activity" do
      get :approve, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to reject an activity" do
      get :reject, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
  end    
  
  context "when logged in as an approver" do
    setup do 
      sign_in users(:users_002)
      Activity.active.where(:approver_id => 2, :ready => true).each{|a|a.questions.first.update_attributes(:raw_answer => 1)}
    end
  
    should "not be able to see any activities list aside from the creator one" do
      [:directorate_governance_eas, :directorate_eas, :my_eas, :actions, :assisting, :quality_control].each do |activity_route|
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
  
    should "be able to see your approver activities" do
      get :approving 
      assert_response :success
    end
  
    should "not be able to view the schedule file for a directorate" do
      get :generate_schedule
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "be able to view the pdf file for an activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :success
    end
  
    should "not be able to submit an activity for approval" do
      get :submit, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to see an activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to see the questions" do
      get :questions, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    # should "be able to toggle the status of an activity" do
    #   post :toggle_strand, :id => activities(:activities_002).id, :strand => "gender"
    #   assert_response :success
    # end
  
    should "not be able to view the creation of activity" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "be able to accept an activity" do
      get :approve, :id => activities(:activities_002).id
      assert_response :success
    end
  
    should "be able to reject an activity" do
      get :reject, :id => activities(:activities_002).id
      assert_response :success
    end
  
  end  
  
end