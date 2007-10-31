#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'strategies_controller'

# Re-raise errors caught by the controller.
class StrategiesController; def rescue_action(e) raise e end; end

class StrategiesControllerTest < Test::Unit::TestCase
  fixtures :strategies

  def setup
    @controller = StrategiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = Strategy.find(:first).id
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
  #   assert_not_nil assigns(:strategies)
  # end
  # 
  # def test_show
  #   get :show, :id => @first_id
  # 
  #   assert_response :success
  #   assert_template 'show'
  # 
  #   assert_not_nil assigns(:strategy)
  #   assert assigns(:strategy).valid?
  # end
  # 
  # def test_new
  #   get :new
  # 
  #   assert_response :success
  #   assert_template 'new'
  # 
  #   assert_not_nil assigns(:strategy)
  # end
  # 
  # def test_create
  #   num_strategies = Strategy.count
  # 
  #   post :create, :strategy => {}
  # 
  #   assert_response :redirect
  #   assert_redirected_to :action => 'list'
  # 
  #   assert_equal num_strategies + 1, Strategy.count
  # end
  # 
  # def test_edit
  #   get :edit, :id => @first_id
  # 
  #   assert_response :success
  #   assert_template 'edit'
  # 
  #   assert_not_nil assigns(:strategy)
  #   assert assigns(:strategy).valid?
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
  #     Strategy.find(@first_id)
  #   }
  # 
  #   post :destroy, :id => @first_id
  #   assert_response :redirect
  #   assert_redirected_to :action => 'list'
  # 
  #   assert_raise(ActiveRecord::RecordNotFound) {
  #     Strategy.find(@first_id)
  #   }
  # end
end
