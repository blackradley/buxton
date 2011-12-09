# #
# # $URL$
# # $Rev$
# # $Author$
# # $Date$
# #
# # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
# #
require 'test_helper'


class StrategiesControllerTest < ActionController::TestCase
  
  should "not be able to access strategies as a non-director" do
    sign_in Factory(:user)
    get :index
    assert_response :redirect
    assert_redirected_to access_denied_path
  end
  
  context "as a corporate cop" do
    setup do
      sign_in Factory(:corporate_cop)
    end
    
    should "be able to access strategies" do
      get :index
      assert_response :success
    end
    
    should "be able to access the new strategy page" do
      get :new
      assert_response :success
    end
    
    should "be able to create new strategies" do
      post :create, :strategy => {:name =>"test strategy", :description =>"to test", :retired=> 0}
      assert_response :redirect
      assert_redirected_to strategies_path
    end
    
    should "be redirected to the same page if the strategy is not created" do
      post :create, :strategy => {}
      assert_response :success
      assert(assigns(:strategy).new_record?)
    end
    
    should "be able vie the edit existing strategies page with a strategy selected" do
      get :edit, :id => 1
      assert_response :success
    end
    
    should "be able to update existing strategies" do
      post :update, :id => 1, :strategy => {:name => "updated test strategy", :description => "to test more", :retired => 0}
      assert_response :redirect
      assert_redirected_to strategies_path
    end
    
    should "be redirected to the same page if the strategy is unsuccessfully updated" do
      post :update, :id => 1, :strategy => {:name => "", :description => ""}
      assert_response :success
    end
    
    should "be able to toggle the retired status of a strategy" do
      post :toggle_retired_status, :checkbox => "retired", :id => 1
      assert_equal Strategy.find(1).retired, true
      assert_response :success
    end
  
  end
  
end