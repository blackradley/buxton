#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'strategy_controller'

# Re-raise errors caught by the controller.
class StrategyController; def rescue_action(e) raise e end; end

class StrategyControllerTest < Test::Unit::TestCase
  fixtures :strategies

  def setup
    @controller = StrategyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = strategies(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:strategies)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:strategy)
    assert assigns(:strategy).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:strategy)
  end

  def test_create
    num_strategies = Strategy.count

    post :create, :strategy => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_strategies + 1, Strategy.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:strategy)
    assert assigns(:strategy).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Strategy.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Strategy.find(@first_id)
    }
  end
end
