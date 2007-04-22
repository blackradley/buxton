#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'function_controller'

# Re-raise errors caught by the controller.
class FunctionController; def rescue_action(e) raise e end; end

class FunctionControllerTest < Test::Unit::TestCase
  fixtures :functions

  def setup
    @controller = FunctionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = functions(:first).id
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

    assert_not_nil assigns(:functions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:function)
    assert assigns(:function).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:function)
  end

  def test_create
    num_functions = Function.count

    post :create, :function => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_functions + 1, Function.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:function)
    assert assigns(:function).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Function.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Function.find(@first_id)
    }
  end
end
