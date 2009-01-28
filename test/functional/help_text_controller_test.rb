#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require File.dirname(__FILE__) + '/../test_helper'

class HelpTextControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  
  def test_cannot_edit_help_text_without_user
    get :index
    assert_redirected_to :controller => 'users'
    get :edit, :id => 1
    assert_redirected_to :controller => 'users'
    put :update, :id => 1
    assert_redirected_to :controller => 'users'  
  end
  
  def test_cannot_edit_help_text_as_organisation_manager
    login_as :organisation_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_edit_help_text_as_activity_manager
    login_as :activity_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_edit_help_text_as_directorate_manager
    login_as :directorate_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
  end
  
  def test_cannot_edit_help_text_as_project_manager
    login_as :project_manager
    get :index
    assert_redirected_to '/users/access_denied'
    get :edit, :id => 1
    assert_redirected_to '/users/access_denied'
    put :update, :id => 1
    assert_redirected_to '/users/access_denied'
  end
end
