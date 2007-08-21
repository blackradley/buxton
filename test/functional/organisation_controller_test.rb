#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'organisation_controller'

# Re-raise errors caught by the controller.
class OrganisationController; def rescue_action(e) raise e end; end

class OrganisationControllerTest < Test::Unit::TestCase
  fixtures :organisations

  def setup
    @controller = OrganisationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = organisations(:first).id
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

    assert_not_nil assigns(:organisations)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:organisation)
    assert assigns(:organisation).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:organisation)
  end

  def test_create
    num_organisations = Organisation.count

    post :create, :organisation => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_organisations + 1, Organisation.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:organisation)
    assert assigns(:organisation).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Organisation.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Organisation.find(@first_id)
    }
  end
end
