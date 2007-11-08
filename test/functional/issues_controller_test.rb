#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'issues_controller'

# Re-raise errors caught by the controller.
class IssuesController; def rescue_action(e) raise e end; end

class IssuesControllerTest < Test::Unit::TestCase
  fixtures :issues
  
  def setup
    @controller = IssuesController.new
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
  
  def test_should_create_issue
    login_as :function_manager
    old_count = Issue.count
    xhr(:post, :create, :issue => { :description => 'An issue description.' })
    assert_equal old_count+1, Issue.count
    assert_response :success
  end
  
  def test_should_render_okay_when_issue_is_created
    login_as :function_manager
    Issue.any_instance.stubs(:save).returns(true)
    post :create
    assert_response :success
  end
  
  def test_should_update_issue
    post :update, :issue => { 1 => {}, 2 => {} }
    assert_response :redirect
  end

  def test_should_destroy_issue
    login_as :function_manager
    old_count = Issue.count
    xhr(:post, :destroy, :id => 1)
    assert_equal old_count-1, Issue.count
    assert_response :success
  end
  
  def test_should_render_okay_when_issue_is_destroyed
    login_as :function_manager
    Issue.any_instance.stubs(:destroy).returns(true)
    xhr(:post, :destroy, :id => 1)
    assert_response :success
  end

end