require File.dirname(__FILE__) + '/../test_helper'
require 'activities_controller'

# Re-raise errors caught by the controller.
class ActivitiesController; def rescue_action(e) raise e end; end

class ActivitiesControllerTest < Test::Unit::TestCase
  fixtures :activities, :users, :organisations, :look_ups, :activities_projects, :terminologies, :organisation_terminologies, :projects

  def setup
    @controller = ActivitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  # A simple test that calls all public actions via all http actions and uses some dummy parameters.
  # There are no assertions in this test, because we don’t know if an action should succeed or redirect.
  # The only thing checked with in this test is that the action does not fail.
  def test_garbage
    ac = ApplicationController.new
    @controller.public_methods.each do |action|
      unless ac.respond_to?(action)
        [:get, :post, :head, :put, :delete].each do |http_method|
          [nil, '', 'abc'*80, '-23', '123456789012345'].each do |param|
            method(http_method).call(action, :id => param)
          end
        end
      end
    end
  end
  
  
  def test_cannot_view_activities_without_user    
    post :new
    assert_redirected_to :controller => 'users'
    post :create
    assert_redirected_to :controller => 'users'
    post :destroy, :id => 1
    assert_redirected_to :controller => 'users' 
    post :edit_contact, :id => 1
    assert_redirected_to :controller => 'users'
    post :update_contact, :id => 1
    assert_redirected_to :controller => 'users'
    get :index
    assert_redirected_to :controller => 'users'
    get :show
    assert_redirected_to :controller => 'users'
    get :questions
    assert_redirected_to :controller => 'users'
    post :update
    assert_redirected_to :controller => 'users'
    post :update_activity_type
    assert_redirected_to :controller => 'users'
    post :update_name
    assert_redirected_to :controller => 'users'
    post :update_ref_no
    assert_redirected_to :controller => 'users'
    post :update_approver
    assert_redirected_to :controller => 'users'
    post :summary
    assert_redirected_to :controller => 'users'
    post :awaiting_approval
    assert_redirected_to :controller => 'users'
    post :approved
    assert_redirected_to :controller => 'users'
    post :incomplete
    assert_redirected_to :controller => 'users'
    post :view, :id => 1
    assert_redirected_to :controller => 'users'
    
  end
  
  def test_cannot_view_activities_as_organisation_manager
    login_as :organisation_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :questions
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
    post :update_activity_type
    assert_redirected_to '/users/access_denied'
    post :update_name
    assert_redirected_to '/users/access_denied'
    post :update_ref_no
    assert_redirected_to '/users/access_denied'
    post :update_approver
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_as_activity_manager
    login_as :activity_manager
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    post :destroy, :id => 1
    assert_redirected_to '/users/access_denied'
    post :edit_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    post :update_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    post :summary
    assert_redirected_to '/users/access_denied'
    post :awaiting_approval
    assert_redirected_to '/users/access_denied'
    post :approved
    assert_redirected_to '/users/access_denied'
    post :incomplete
    assert_redirected_to '/users/access_denied'
    post :view, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_as_directorate_manager
    login_as :directorate_manager
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    post :destroy, :id => 1  ##error
    assert_redirected_to '/users/access_denied'
    post :edit_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    post :update_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    get :index
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :questions
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
    post :update_activity_type
    assert_redirected_to '/users/access_denied'
    post :update_name
    assert_redirected_to '/users/access_denied'
    post :update_ref_no
    assert_redirected_to '/users/access_denied'
    post :update_approver
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_as_project_manager
    login_as :project_manager
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    post :destroy, :id => 1 ##error
    assert_redirected_to '/users/access_denied'
    post :edit_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    post :update_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    get :index
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :questions
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
    post :update_activity_type
    assert_redirected_to '/users/access_denied'
    post :update_name
    assert_redirected_to '/users/access_denied'
    post :update_ref_no
    assert_redirected_to '/users/access_denied'
    post :update_approver
    assert_redirected_to '/users/access_denied'
  end
  
  
  def test_can_view_activities_as_administrator
    login_as :administrator
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    post :destroy, :id => 1
    assert_redirected_to '/users/access_denied'
    post :edit_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    post :update_contact, :id => 1
    assert_redirected_to '/users/access_denied'
    get :index
    assert_redirected_to '/users/access_denied'
    get :show
    assert_redirected_to '/users/access_denied'
    get :questions
    assert_redirected_to '/users/access_denied'
    post :update
    assert_redirected_to '/users/access_denied'
    post :update_activity_type
    assert_redirected_to '/users/access_denied'
    post :update_name
    assert_redirected_to '/users/access_denied'
    post :update_ref_no
    assert_redirected_to '/users/access_denied'
    post :update_approver
    assert_redirected_to '/users/access_denied'
    post :summary
    assert_redirected_to '/users/access_denied'
    post :awaiting_approval
    assert_redirected_to '/users/access_denied'
    post :approved
    assert_redirected_to '/users/access_denied'
    post :incomplete
    assert_redirected_to '/users/access_denied'
    post :view, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_with_wrong_project_manager
    login_as :project_manager_2
    post :view, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_with_wrong_directorate_manager
    login_as :directorate_manager_2
    post :view, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_activities_with_wrong_organisation_manager
    login_as :organisation_manager_2
    [:edit_contact, :update_contact, :destroy].each do |method|
      post method, :id => 1
      assert_redirected_to '/users/access_denied'
    end
    post :view
    post method, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  
  def test_can_view_activities_with_right_activity_manager
    login_as :activity_manager
    post :update_activity_type
    assert_redirected_to :action => 'questions'
    [:index, :show, :questions, :update, :update_name, :update_ref_no, :update_approver].each do |method|
      post method
      assert_response :success
    end
  end
  
  def test_can_view_activities_with_right_project_manager
    login_as :project_manager
    [:summary, :awaiting_approval, :approved, :incomplete].each do |method|
      post method
      assert_response :success
    end
    post :view, :id => 1
    assert_response :success
  end
  
  def test_can_view_activities_with_right_directorate_manager
    login_as :directorate_manager
    [:summary, :awaiting_approval, :approved, :incomplete].each do |method|
      post method
      assert_response :success
    end
    post :view, :id => 1
    assert_response :success
  end
  
  def test_can_view_activities_with_right_organisation_manager
    login_as :organisation_manager
    post :create
    assert_redirected_to :action => :incomplete
    [:new, :summary, :awaiting_approval, :approved, :incomplete].each do |method|
      post method
      assert_response :success
    end
    [:edit_contact, :update_contact, :destroy, :view].each do |method|
      post method, :id => 1
      assert_response :success
    end
  end
end