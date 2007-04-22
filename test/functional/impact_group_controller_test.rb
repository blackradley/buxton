#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'impact_group_controller'

# Re-raise errors caught by the controller.
class ImpactGroupController; def rescue_action(e) raise e end; end

class ImpactGroupControllerTest < Test::Unit::TestCase
  fixtures :impact_groups

  def setup
    @controller = ImpactGroupController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = impact_groups(:first).id
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

    assert_not_nil assigns(:impact_groups)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:impact_group)
    assert assigns(:impact_group).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:impact_group)
  end

  def test_create
    num_impact_groups = ImpactGroup.count

    post :create, :impact_group => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_impact_groups + 1, ImpactGroup.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:impact_group)
    assert assigns(:impact_group).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ImpactGroup.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ImpactGroup.find(@first_id)
    }
  end
end
