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
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
    should "not be able to view the schedule file for a directorate" do
      get :generate_schedule
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to view the pdf file for an activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
    
    should "not be able to QC review and comment on an activity" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
  end
  
  context "when logged in as a directorate cop " do
    setup do 
      sign_in users(:users_001)
    end
    
    should "not be able to see any activities list aside from the cop ones" do
      [:directorate_eas, :my_eas, :approving, :assisting, :quality_control].each do |activity_route|
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
    
    should "not be able to view the PDF file for an activity that's not in their directorate" do
      get :show, :id => Factory(:activity, :service_area => service_areas(:service_areas_002)).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to see an activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to see an activity summary for an activity that's not in their directorate" do
      get :show, :id => Factory(:activity, :service_area => service_areas(:service_areas_002)).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the questions" do
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
    
    should "not be able to comment on an activity as a QC" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
  end
  
  context "when logged in as a corporate cop " do
    setup do 
      sign_in Factory(:corporate_cop)
    end
    
    should "not be able to see any activities list aside from the cop ones" do
      [:directorate_eas, :my_eas, :approving, :assisting, :quality_control].each do |activity_route|
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
    
    
    should "be able to view the pdf file for any activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "be able to see any activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to see the questions" do
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
    
    should "not be able to comment on an activity as a QC" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
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
    
    should "not be able to view the PDF file for an activity that's not in their directorate" do
      get :show, :id => Factory(:activity, :service_area => service_areas(:service_areas_002)).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to see an activity summary" do
      get :summary, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to see an activity summary for an activity that's not in their directorate" do
      get :show, :id => Factory(:activity, :service_area => service_areas(:service_areas_002)).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
    
    should "not be able to comment on an activity as a QC" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
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
    
    should "not be able to submit an activity if it's not their assigned activity" do
      get :submit, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
    
    should "not be able to view the pdf file for an activity for which one is not the completer" do
      get :show, :id => activities(:activities_001).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
    
    should "not be able to see the questions of an activity for which one is not the completer" do
      get :questions, :id => activities(:activities_003).id
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
    
    should "not be able to comment on an activity" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "be able to see the task group management page for an activity they are the completer for" do
      get :task_group, :id => 2
      assert_response :success
    end
    
    should "not be able to see the task group management page for an activity they are not a completer for" do
      get :task_group, :id => 3
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :success
    end
    
    should "not be able to see the add new task group member page for an activity for which they are not the completer" do
      get :add_task_group_member, :id => 3
      assert_redirected_to access_denied_path
    end
    
    should "be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 2
      assert_response :success
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
    should "not be able to add users to the task group for an activity for which they are not the completer" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to task_group_activity_path(2)
      assert !activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
    should "not be able to remove users from the task group for an activity for which they are not the completer" do
      post :remove_task_group_member, :id => 3, :user_id => 8
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_003).task_group_memberships.find_by_activity_id(3)
    end
    
  end    
  
  context "when logged in as an approver" do
    setup do 
      sign_in users(:users_002)
      Activity.active.where(:approver_id => 2, :ready => true).each{|a|a.questions.first.update_attributes(:raw_answer => 1)}
    end
  
    should "not be able to see any activities list aside from the approver one" do
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
    
    should "not be able to view the pdf file for an activity for which one is not the approver" do
      get :show, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
  
    should "not be able to view the creation of activity" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "be able to accept an activity" do
      get :approve, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to accept an activity for which one is not the approver" do
      get :approve, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to accept an activity that has not been submitted for approval" do
      activities(:activities_003).update_attributes!(:submitted => false)
      get :approve, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "be able to reject an activity" do
      get :reject, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to reject an activity for which one is not the approver" do
      get :reject, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to reject an activity that has not been submitted for approval" do
      activities(:activities_003).update_attributes!(:submitted => false)
      get :reject, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to comment on an activity as a QC" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as an assistant" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
  
  end  
  
  context "when logged in as a quality controller" do
    setup do
      sign_in users(:users_006)
      Activity.active.where(:qc_officer_id => 6, :ready => true).each{|a|a.questions.first.update_attributes(:raw_answer => 1)}
      activities(:activities_002).update_attributes(:submitted => true)
    end
    
    should "not be able to see any activities list aside from the QC one" do
      [:my_eas, :directorate_governance_eas, :directorate_eas, :approving, :actions, :assisting].each do |activity_route|
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
    should "be able to see the awaiting quality control view" do
      get :quality_control
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
    
    should "not be able to view the pdf file for an activity for which they are not the QC" do
      get :show, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
    
    should "be able to comment on an activity submitted for commenting" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :subject => "email subject", :email_contents => "this activity passed the test"
      assert_redirected_to quality_control_activities_path
      assert Activity.find(2).undergone_qc
    end
    
    should "not be able to comment on an activity submitted for commenting that is not assigned to the QC" do
      xhr :post, :submit_comment, :id => activities(:activities_003).id, :subject => "email subject", :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(1).undergone_qc
    end
    
    should "not be able to comment on an activity that has not been submitted for commenting" do
      activities(:activities_003).update_attributes!(:submitted => false)
      xhr :post, :submit_comment, :id => activities(:activities_003).id, :subject => "email subject", :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
  end
  
  context "a task group member" do
    setup do
      sign_in users(:users_007)
    end
    
    should "be unable to see any activities list aside from the assisting one" do
      [:my_eas, :directorate_governance_eas, :directorate_eas, :approving, :actions, :quality_control].each do |activity_route|
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
    should "be able to see the list of activities they are assisting on" do
      get :assisting
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
    
    should "not be able to QC review and comment on an activity" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "be able to make comments on activities they are assisting on" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to assisting_activities_path
      @email = ActionMailer::Base.deliveries.last
      assert_equal @email.subject, "Test comment Subject"
      assert_equal @email.to[0], "shaun@27stars.co.uk"
      assert_match /Test Comment Contents/, @email.body
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
  end
  
  context "a user with no roles whatsoever" do
    setup do
      sign_in Factory(:user)
    end
    
    should "not be able to see any activities list" do
      [:directorate_eas, :my_eas, :approving, :directorate_governance_eas, :actions, :assisting, :quality_control].each do |activity_route|
        get activity_route
        assert_response :redirect
        assert_redirected_to access_denied_path
      end
    end
    
    should "not be able to view the schedule file for a directorate" do
      get :generate_schedule
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
  
    should "not be able to view the pdf file for an activity" do
      get :show, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to access_denied_path
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
    
    should "not be able to QC review and comment on an activity" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to make comments on activities as though they are assistants" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the task group management page for an activity" do
      get :task_group, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to see the add new task group member page" do
      get :add_task_group_member, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "not be able to add users to the task group for an activity" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert !activities(:activities_001).task_group_memberships.find_by_activity_id(1)
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_002).task_group_memberships.find_by_activity_id(2)
    end
    
  end
  
end