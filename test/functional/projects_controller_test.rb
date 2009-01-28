#
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/test/functional/projects_controller_test.rb $
# $Rev: 1264 $
# $Author: 27stars-karl $
# $Date: 2008-05-22 20:26:19 +0100 (Thu, 22 May 2008) $
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require File.dirname(__FILE__) + '/../test_helper'
require 'projects_controller'

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < Test::Unit::TestCase
  fixtures :projects, :users, :organisations, :look_ups
  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_cannot_view_projects_without_user
    options = { :controller => 'projects',
                :action => 'index',
                :organisation_id => '1' }
    assert_routing('organisations/1/projects', options)
    
    get :index, :organisation_id => 1
    assert_redirected_to :controller => 'users'
    get :show, :organisation_id => 1, :id => 1
    assert_redirected_to :controller => 'users'
    get :edit, :organisation_id => 1, :id => 1
    assert_redirected_to :controller => 'users'
    post :new, :organisation_id => 1
    assert_redirected_to :controller => 'users'
    post :create, :organisation_id => 1
    assert_redirected_to :controller => 'users'
    put :update, :organisation_id => 1, :id => 1
    assert_redirected_to :controller => 'users'
    delete :destroy, :organisation_id => 1, :id => 1
    assert_redirected_to :controller => 'users'  
  end
  
  def test_cannot_view_projects_as_organisation_manager
    login_as :organisation_manager
    get :index, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    get :show, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    post :create, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_projects_as_activity_manager
    login_as :activity_manager
    get :index, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    get :show, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    post :create, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_projects_as_directorate_manager
    login_as :directorate_manager
    get :index, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    get :show, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    post :create, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_projects_as_project_manager
    login_as :project_manager
    get :index, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    get :show, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    post :create, :organisation_id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :organisation_id => 1, :id => 1
    assert_redirected_to '/users/access_denied'
  end
end