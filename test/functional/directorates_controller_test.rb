# #
# # $URL$
# # $Rev$
# # $Author$
# # $Date$
# #
# # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
# #
require 'test_helper'
# require 'directorates_controller'
#
class DirectoratesControllerTest < ActionController::TestCase
  # fixtures :directorates

  context "A creator" do
    setup do
      @creator = Factory(:creator)
      sign_in @creator
    end

    should "be able to see a list of directorates" do
      get :index
      assert_response :success
    end

    should "be able to see the new directorates page" do
      get :new
      assert_response :success
    end

    should "be able to create directorates" do
      post :create, :directorate => {:name => "Test Directorate", :cop_email => Factory(:cop).email}
      assert_equal "Test Directorate", Directorate.where(:name => "Test Directorate").first.name
      assert_response :redirect
      assert_redirected_to :action => "index"
    end

    should "be able to toggle the retired status of a directorate" do
      directorate = Factory.create(:directorate, :creator => @creator)
      post :toggle_directorate_status, :id => directorate.id, :checkbox => 'retired'
      assert_equal true, Directorate.find(directorate.id).retired
      assert_response :success
    end

    should "be able to see the edit directories page" do
      get :edit, :id => directorates(:directorates_001).id
      assert_response :success
    end

    should "be able to update the properties of a directorate" do
      post :update, :id => 1, :directorate => {:name => "Test Directorate 2", :cop_email => Factory(:cop).email}
      assert_equal "Test Directorate 2", Directorate.find(1).name
      assert_response :redirect
      assert_redirected_to :action => "index"
    end

    should "not be able to create a directorate if they have assigned someone who is already a creator for another directorate" do
      # post :create, :directorate => {:name => "Test Directorate", :cop_email => "joe@27stars.co.uk", :creator_email => users(:users_004).email}
      # assert_response :success
      # assert(assigns(:directorate).new_record?)
    end

    should "not be able to create a directorate if they have not assigned a corp cop" do
      post :create, :directorate => {:name => "Test Directorate"}
      assert_response :success
      assert(assigns(:directorate).new_record?)
    end

    should "not be able to update a directorate if they have assigned someone who is already a creator for another directorate" do
      # post :update, :id => directorates(:directorates_002), :directorate => {:name => "Test Directorate", :cop_email => "joe@27stars.co.uk", :creator_email => users(:users_004).email}
      # assert_response :success
      # assert(!assigns(:directorate).valid?)
    end

    should "not be able to update a directorate if they have not assigned a corp cop" do
      post :update, :id => directorates(:directorates_002), :directorate => {:name => "Test Directorate"}
      assert_response :success
      assert(!assigns(:directorate).valid?)
    end

  end

end
