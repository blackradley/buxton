#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'organisations_controller'

# Re-raise errors caught by the controller.
class OrganisationsController; def rescue_action(e) raise e end; end

class OrganisationsControllerTest < Test::Unit::TestCase
  fixtures :organisations

  def setup
    @controller = OrganisationsController.new
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
  
  def test_cannot_view_organisations_without_user
    get :index
    assert_redirected_to :controller => 'users'
    get :show, :id => 1
    assert_redirected_to :controller => 'users'
    get :edit, :id => 1
    assert_redirected_to :controller => 'users'
    post :new
    assert_redirected_to :controller => 'users'
    post :create
    assert_redirected_to :controller => 'users'
    put :update, :id => 1
    assert_redirected_to :controller => 'users'
    delete :destroy, :id => 1
    assert_redirected_to :controller => 'users'  
  end
  
  def test_cannot_view_organisations_as_organisation_manager
    login_as :organisation_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :show, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_organisations_as_activity_manager
    login_as :activity_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :show, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_organisations_as_directorate_manager
    login_as :directorate_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :show, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_view_organisations_as_project_manager
    login_as :project_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :show, :id => 1
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    post :new
    assert_redirected_to '/users/access_denied'
    post :create
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
    delete :destroy, :id => 1
    assert_redirected_to '/users/access_denied'
  end


  # def test_index
  #   get :index
  #   assert_response :success
  #   assert_template 'list'
  # end
  # 
  # def test_list
  #   get :list
  # 
  #   assert_response :success
  #   assert_template 'list'
  # 
  #   assert_not_nil assigns(:organisations)
  # end
  # 
  # def test_show
  #   get :show, :id => @first_id
  # 
  #   assert_response :success
  #   assert_template 'show'
  # 
  #   assert_not_nil assigns(:organisation)
  #   assert assigns(:organisation).valid?
  # end
  # 
  # def test_new
  #   get :new
  # 
  #   assert_response :success
  #   assert_template 'new'
  # 
  #   assert_not_nil assigns(:organisation)
  # end
  # 
  # def test_create
  #   num_organisations = Organisation.count
  # 
  #   post :create, :organisation => {}
  # 
  #   assert_response :redirect
  #   assert_redirected_to :action => 'list'
  # 
  #   assert_equal num_organisations + 1, Organisation.count
  # end
  # 
  # def test_edit
  #   get :edit, :id => @first_id
  # 
  #   assert_response :success
  #   assert_template 'edit'
  # 
  #   assert_not_nil assigns(:organisation)
  #   assert assigns(:organisation).valid?
  # end
  # 
  # def test_update
  #   post :update, :id => @first_id
  #   assert_response :redirect
  #   assert_redirected_to :action => 'show', :id => @first_id
  # end
  # 
  # def test_destroy
  #   assert_nothing_raised {
  #     Organisation.find(@first_id)
  #   }
  # 
  #   post :destroy, :id => @first_id
  #   assert_response :redirect
  #   assert_redirected_to :action => 'list'
  # 
  #   assert_raise(ActiveRecord::RecordNotFound) {
  #     Organisation.find(@first_id)
  #   }
  # end
end
