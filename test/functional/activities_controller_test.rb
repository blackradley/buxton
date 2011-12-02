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
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
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
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
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
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
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
      assert assigns(:service_areas)
      assert_response :success
    end
    
    should "be able to create an activity and send it to the completer" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 4, Activity.count
      assert_redirected_to directorate_eas_activities_path
    end
    
    should "not be able to create an activity and send it to the completer if no completer is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:completer_email].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if no approver is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:approver_email].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if no QC officer is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:qc_officer_email].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if no start date is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:start_date].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if no end date is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:end_date].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if no review date is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:review_on].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if no name is supplied" do
      post :create, :activity => {:name => "", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:name].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send if an invalid completer is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "gibberish", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:completer_email].blank?
      assert_response :success
    end
    
    should "not be able to create an activity if an invalid approver is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "creator2@27stars.co.uk", :approver_email => "gibberish", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:approver_email].blank?
      assert_response :success
    end
    
    should "not be able to create an activity if an invalid QC officer is supplied" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "gibberish", :type => 0, :activity_status => 0}
      assert_equal 3, Activity.count
      assert !assigns(:activity).errors[:qc_officer_email].blank?
      assert_response :success
    end
    
    should "not be able to create an activity and send it to the completer if it is a clone from a retired service area" do
      ServiceArea.find(1).update_attributes(:retired => true)
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}, :clone_of => activities(:activities_001).id.to_s
      assert_equal 3, Activity.count
      assert_equal "The Service Area for this EA has been retired and therefore this EA cannot be cloned.", flash[:notice]
    end
    
    should "be able to create an activity and send it to the completer when cloning it from another activity" do
      post :create, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}, :clone_of => activities(:activities_001).id.to_s
      assert_equal 4, Activity.count
    end
    
    should "be able to view the edit page of an activity that has not been sent to the completer" do
      activities(:activities_001).update_attributes(:ready => false)
      get :edit, :id => activities(:activities_001).id
      assert assigns(:service_areas)
      assert_response :success
    end
    
    should "not be able to view the edit page of an activity that has been sent to the completer" do
      activities(:activities_001).update_attributes(:ready => true)
      get :edit, :id => activities(:activities_001).id
      assert_redirected_to access_denied_path
    end
    
    should "be able to update the attributes of activites that have not been sent to the completer" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "creator2@27stars.co.uk", :type => 0, :activity_status => 0}
      @activity.reload
      assert_redirected_to directorate_eas_activities_path
      assert_equal "test activity", @activity.name
      assert_equal 8, @activity.completer_id
      assert_equal 8, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
    end
    
    should "not be able to update the attributes of activities and send them to the completer if there is no completer assigned" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "helper@27stars.co.uk", :type => 0, :activity_status => 0}
      @activity.reload
      assigns(:activity).errors[:completer_email].first
      assert_equal "An EA must have someone assigned to undergo the assessment", assigns(:activity).errors[:completer_email].first
      assert_equal "Shauns Activity 0", @activity.name
      assert_equal 5, @activity.completer_id
      assert_equal 2, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
      assert_response :success
    end
    
    should "not be able to update the attributes of activities and send them to the completer if there is no approver assigned" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "", :qc_officer_email => "helper@27stars.co.uk", :type => 0, :activity_status => 0}
      @activity.reload
      assert_equal "An EA must have someone assigned to approve the assessment", assigns(:activity).errors[:approver_email].first
      assert_equal "Shauns Activity 0", @activity.name
      assert_equal 5, @activity.completer_id
      assert_equal 2, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
      assert_response :success
    end
    
    should "not be able to update the attributes of activities and send them to the completer if there is no qc officer assigned" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "true", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "", :type => 0, :activity_status => 0}
      @activity.reload
      assert_equal "An EA must have someone assigned as a Quality Control Officer for the assessment", assigns(:activity).errors[:qc_officer_email].first
      assert_equal "Shauns Activity 0", @activity.name
      assert_equal 5, @activity.completer_id
      assert_equal 2, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
      assert_response :success
    end
    
    should "not be able to update the attributes of activities if there is an invalid completer assigned" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "fewfgwars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "helper@27stars.co.uk", :type => 0, :activity_status => 0}
      @activity.reload
      assert_equal "is not a valid user", assigns(:activity).errors[:completer_email].first
      assert_equal "Shauns Activity 0", @activity.name
      assert_equal 5, @activity.completer_id
      assert_equal 2, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
      assert_response :success
    end
    
    should "not be able to update the attributes of activities if there is an invalid approver assigned" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "creator2@27stars.co.uk", :approver_email => "er7stars.co.uk", :qc_officer_email => "helper@27stars.co.uk", :type => 0, :activity_status => 0}
      @activity.reload
      assert_equal "is not a valid user", assigns(:activity).errors[:approver_email].first
      assert_equal "Shauns Activity 0", @activity.name
      assert_equal 5, @activity.completer_id
      assert_equal 2, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
      assert_response :success
    end
    
    should "not be able to update the attributes of activities if there is an invalid qc officer assigned" do
      @activity = activities(:activities_001)
      @activity.update_attributes(:ready => false)
      post :update, :id => @activity.id, :activity => {:name => "test activity", :service_area => ServiceArea.find(1), :start_date => "2011-04-14 14:32:55", :end_date => "2011-04-14 14:32:55", :review_on => "2011-04-14 14:32:55", :ready => "false", :completer_email => "creator2@27stars.co.uk", :approver_email => "creator2@27stars.co.uk", :qc_officer_email => "helpear@27starewcf", :type => 0, :activity_status => 0}
      @activity.reload
      assert_equal "is not a valid user", assigns(:activity).errors[:qc_officer_email].first
      assert_equal "Shauns Activity 0", @activity.name
      assert_equal 5, @activity.completer_id
      assert_equal 2, @activity.approver_id
      assert_equal 8, @activity.qc_officer_id
      assert_response :success
    end
    
    should "be able to create a clone of an activity" do
      @activity = activities(:activities_001)
      get :clone, :id => @activity.id
      assert_response :success
    end
    
    should "not be able to create a clone of an activity that is not in the service area of the creator" do
      @activity = activities(:activities_003)
      get :clone, :id => @activity.id
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
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
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
    
    should "be able to see the list of EAs they are completer for" do
      get :my_eas
      assert_response :success
    end
    
    should "be able to successfully submit an activity for approval" do
      @activity = activities(:activities_002)
      @activity.questions.where(:section => "purpose").each do |q|
        q.update_attributes(:raw_answer => "2")
      end
      @activity.questions.where(:name => "purpose_age_3").first.update_attributes(:raw_answer => 1)
      @activity.update_attributes(:gender_relevant => true)
      @activity.questions.where(:section => "impact", :strand => "gender").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.questions.where(:section => "consultation", :strand => "gender").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.questions.where(:section => "additional_work", :strand => "gender").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.questions.where(:section => "impact", :strand => "age").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.questions.where(:section => "consultation", :strand => "age").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.questions.where(:section => "additional_work", :strand => "age").each do |q|
        q.update_attributes(:raw_answer => "1")
      end
      @activity.issues.create(:actions => "Action", :timescales => "timescale", :lead_officer => "Joe", :strand => "gender", :section => "impact", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
      @activity.issues.create(:actions => "Action", :timescales => "timescale", :lead_officer => "Joe", :strand => "gender", :section => "consultation", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:actions => "Action", :timescales => "timescale", :lead_officer => "Joe", :strand => "age", :section => "impact", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
        @activity.issues.create(:actions => "Action", :timescales => "timescale", :lead_officer => "Joe", :strand => "age", :section => "consultation", :resources => "none", :description => "Issue description", :recommendations => "none", :monitoring => "none", :outcomes => "none")
      post :submit, :id => @activity.id
      assert_response :redirect
      assert_redirected_to questions_activity_path(@activity)
      @activity.reload
      assert @activity.submitted
      assert_equal "Your EA has been successfully submitted for approval.", flash[:notice]
    end
    
    should "not be able to submit an activity if it's not been completed" do
      post :submit, :id => activities(:activities_002).id
      assert_response :redirect
      assert_redirected_to questions_activity_path(activities(:activities_002).id)
      assert !activities(:activities_002).submitted
      assert_equal "You need to finish your EA before you can submit it.", flash[:error]
    end
    
    should "not be able to submit an activity if it's not their assigned activity" do
      post :submit, :id => activities(:activities_003).id
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
    
    should "not be able to comment on an activity as a QC" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 2, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to add users to the task group for an activity for which they are not the completer" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => Factory(:user).email}, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to add users to a task group if the user does not exist" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => "invalid@example.com"}, :id => 2
      assert_response :success
      activity = assigns(:activity)
      assert_equal "You must enter a valid user", activity.errors[:task_group_member].first
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to add users to a task group if the user is already added to that task group" do
      xhr :post, :create_task_group_member, :activity => {:task_group_member => "helper@27stars.co.uk"}, :id => 2
      assert_response :success
      activity = assigns(:activity)
      assert_equal "This person has already been added to the task group.", activity.errors[:task_group_member].first
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to task_group_activity_path(2)
      assert_equal 0, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity for which they are not the completer" do
      post :remove_task_group_member, :id => 3, :user_id => 8
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert activities(:activities_003).task_group_memberships
    end
    
    should "be able to toggle strands in an activity" do
      @activity = activities(:activities_002)
      @activity.update_attributes(:undergone_qc => false, :submitted => false)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert_response :success
      assert @activity.gender_relevant
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert_response :success
      assert !@activity.gender_relevant
    end
    
    should "not be able to toggle strands in an activity if that strand is required" do
      @activity = activities(:activities_002)
      @activity.questions.where(:name => "purpose_gender_3").first.update_attributes(:raw_answer => 1)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
    end
    
    should "not be able to toggle strands in an activity that is submitted" do
      @activity = activities(:activities_002)
      @activity.update_attributes(:undergone_qc => true, :submitted => true)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
    end
    
    should "not be able to toggle strands in an activity one is not the completer for" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
    end
    
  end    
  
  context "when logged in as an approver" do
    setup do 
      sign_in users(:users_002)
      activities(:activities_002).update_attributes!(:submitted => true, :undergone_qc => true)
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
  
    should "be able to view the approve activity page of an activity that is submitted and has undergone QC" do
      get :approve, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to view the approve activity page of an activity for which one is not the approver" do
      get :approve, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to view the reject activity page of an activity" do
      get :reject, :id => activities(:activities_002).id
      assert_response :success
    end
    
    should "not be able to view the reject activity page of an activity for which one is not the approver" do
      get :reject, :id => activities(:activities_003).id
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to submit their approval of an activity" do
      @activity = activities(:activities_002)
      xhr :post, :submit_approval,:id => @activity.id, :email_contents => "This activity has been approved", :subject => "Email subject"
      assert_redirected_to approving_activities_path
      assert_equal flash[:notice], "Successfully approved #{@activity.name}"
      @activity.reload
      assert @activity.approved
      @email = ActionMailer::Base.deliveries.last
      assert_equal @email.subject, "Email subject"
      assert_equal @email.to[0], @activity.completer.email
      assert_match /This activity has been approved/, @email.body
    end
    
    should "not be able to submit the approval of an activity that they are not approver for" do
      @activity = activities(:activities_003)
      xhr :post, :submit_approval,:id => @activity.id, :email_contents => "This activity has been approved when it should not have been", :subject => "Email subject"
      @activity.reload
      assert !@activity.approved
      @email = ActionMailer::Base.deliveries.last
      assert_not_equal @email.subject, "Email subject"
      assert_not_equal @email.to[0], @activity.completer.email
    end
    
    should "not be able to submit the approval of an activity that has not been submitted for approval or QC checked" do
      @activity = activities(:activities_002)
      @activity.update_attributes(:undergone_qc => false, :submitted => false)
      xhr :post, :submit_approval,:id => @activity.id, :email_contents => "This activity has been approved when it should not have been", :subject => "Email subject2"
      @activity.reload
      assert !@activity.approved
      @email = ActionMailer::Base.deliveries.last
      assert_not_equal @email.subject, "Email subject2"
      assert_not_equal @email.to[0], @activity.completer.email
    end
    
    should "be able to submit their rejection of an activity that has been submitted for approval and has been QC checked. This should create a clone." do
      @activity = activities(:activities_002)
      xhr :post, :submit_rejection, :id => @activity.id, :email_contents => "This activity has been successfully rejected", :subject => "Email subject"
      assert_equal flash[:notice], "#{@activity.name} rejected."
      @activity.reload
      assert @activity.is_rejected
      @email = ActionMailer::Base.deliveries.last
      assert_equal @email.subject, "Email subject"
      assert_equal @email.to[0], @activity.completer.email
      assert_match /activity has been successfully rejected/, @email.body
      assert !Activity.find_by_id(@activity.id)
    end
    
    should "not be able to submit their rejection of an activity that has not been submitted for approval or has not been QC checked. This should not create a clone" do
      @activity = activities(:activities_002)
      @activity.update_attributes(:submitted => false, :undergone_qc => false)
      xhr :post, :submit_rejection, :id => @activity.id, :email_contents => "This activity has been successfully rejected", :subject => "Email subject"
      @activity.reload
      assert !@activity.is_rejected
      @email = ActionMailer::Base.deliveries.last
      assert_not_equal @email.subject, "Email subject"
      assert_not_equal @email.to[0], @activity.completer.email
      assert Activity.find_by_id(@activity.id)
    end
          
    should "not be able to comment on an activity as a QC" do
      @activity = activities(:activities_002)
      activities(:activities_002).update_attributes(:undergone_qc => false)
      xhr :post, :submit_comment, :id => @activity.id, :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
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
  
    should "be able to reject an activity, and this should create a clone" do
      @activity = activities(:activities_002)
      xhr :post, :submit_rejection, :id => @activity.id, :email_contents => "This activity has been successfully rejected", :subject => "Email subject"
      assert_equal flash[:notice], "#{@activity.name} rejected."
      @activity.reload
      assert @activity.is_rejected
      @email = ActionMailer::Base.deliveries.last
      assert_equal @email.subject, "Email subject"
      assert_equal @email.to[0], @activity.completer.email
      assert_match /activity has been successfully rejected/, @email.body
      assert !Activity.find_by_id(@activity.id)
    end
    
    should "be able to see the comment creation box" do
      get :comment, :id => 2
      assert_response :success
    end
    
    should "be able to comment on an activity submitted for commenting" do
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :subject => "email subject", :email_contents => "this activity passed the test"
      assert_equal flash[:notice], "Successfully performed Quality Control on #{activities(:activities_002).name}"
      assert_redirected_to quality_control_activities_path
      assert Activity.find(2).undergone_qc
    end
    
    should "not be able to comment on an activity submitted for commenting that is not assigned to the QC" do
      xhr :post, :submit_comment, :id => activities(:activities_003).id, :subject => "email subject", :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(3).undergone_qc
    end
    
    should "not be able to comment on an activity that has not been submitted for commenting" do
      activities(:activities_002).update_attributes!(:submitted => false)
      xhr :post, :submit_comment, :id => activities(:activities_002).id, :subject => "email subject", :email_contents => "this activity passed the test"
      assert_redirected_to access_denied_path
      assert !Activity.find(2).undergone_qc
    end
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
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
    
    should "be able to see the comments box" do
      get :task_group_comment_box, :id => 2
      assert_response :success
    end
    
    should "not be able to see the comments box for activities they are not assisting on" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
    end
    
    should "be able to make comments on activities they are assisting on" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 2, :email_contents => "Test Comment Contents"
      assert_redirected_to assisting_activities_path
      @email = ActionMailer::Base.deliveries.last
      assert_equal @email.subject, "Test comment Subject"
      assert_equal @email.to[0], "shaun@27stars.co.uk"
      assert_match /Test Comment Contents/, @email.body
    end
    
    should "not be able to make comments on activities they are not assisting on" do
      xhr :post, :make_task_group_comment, :subject => "Test comment Subject", :id => 1, :email_contents => "Test Comment Contents"
      assert_redirected_to access_denied_path
      @email = ActionMailer::Base.deliveries.last
      assert_not_equal @email.subject, "Test comment Subject"
      assert_not_equal @email.to[0], "shaun@27stars.co.uk"
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
    end
    
  end
  
  context "a user with no roles whatsoever" do
    setup do
      sign_in Factory(:user)
    end
    
    should "be able to access the index page and get redirected appropriately" do
      get :index
      assert_response :redirect
      assert_redirected_to root_path
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
    
    should "not be able to see the task group member comments box" do
      get :task_group_comment_box, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
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
      assert_equal 0, activities(:activities_001).task_group_memberships.count
    end
    
    should "not be able to remove users from the task group for an activity" do
      post :remove_task_group_member, :id => 2, :user_id => 7
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal 1, activities(:activities_002).task_group_memberships.count
    end
    
    should "not be able to toggle strands in an activity" do
      @activity = activities(:activities_003)
      post :toggle_strand, :id => @activity.id, :strand => "gender"
      @activity.reload
      assert !@activity.gender_relevant
    end
    
  end
  
end