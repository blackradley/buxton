#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = User.find(:first).id
  end

  # Replace this with your real tests.
  def test_truth
    assert true
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
  #   assert_not_nil assigns(:users)
  # end
  # 
  # def test_new
  #   get :new
  # 
  #   assert_response :success
  #   assert_template 'new'
  # 
  #   assert_not_nil assigns(:user)
  # end
  # 
  # def test_create
  #   num_users = User.count
  # 
  #   post :create, :user => {}
  # 
  #   assert_response :redirect
  #   assert_redirected_to :action => 'list'
  # 
  #   assert_equal num_users + 1, User.count
  # end
  # 
  # def test_edit
  #   get :edit, :id => @first_id
  # 
  #   assert_response :success
  #   assert_template 'edit'
  # 
  #   assert_not_nil assigns(:user)
  #   assert assigns(:user).valid?
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
  #     User.find(@first_id)
  #   }
  # 
  #   post :destroy, :id => @first_id
  #   assert_response :redirect
  #   assert_redirected_to :action => 'list'
  # 
  #   assert_raise(ActiveRecord::RecordNotFound) {
  #     User.find(@first_id)
  #   }
  # end
end
