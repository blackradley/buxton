require 'test_helper'

class ServiceAreasControllerTest < ActionController::TestCase

  #TODO Directorate cops are the ones who edit/create service areas, it seems
  context "A user that is not a creator" do
    setup do
      sign_in Factory(:user)
    end

    should "be unable to access the Service Areas table" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the New Service Area page" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to create new Service Areas" do
      post :create
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the Edit Service Area page" do
      get :edit, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to update existing Service Areas" do
      post :update, :id => 1, :service_area => {:name => "Edited Service Area"}
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal ServiceArea.find(1).name, "Sample Service Area"
    end

    should "be unable to toggle the retired status of Service Areas" do
      post :toggle_retired_status, :id => 1, :checkbox => "retired"
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal false, ServiceArea.find(1).retired
    end

  end

  context "A user that is a creator but is not in charge of a directorate" do
    setup do
      sign_in Factory(:creator)
    end

    should "be unable to access the Service Areas table" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the New Service Area page" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to create new Service Areas" do
      post :create
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the Edit Service Area page" do
      get :edit, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to update existing Service Areas" do
      post :update, :id => 1, :service_area => {:name => "Edited Service Area"}
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal ServiceArea.find(1).name, "Sample Service Area"
    end

    should "be unable to toggle the retired status of Service Areas" do
      post :toggle_retired_status, :id => 1, :checkbox => "retired"
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal false, ServiceArea.find(1).retired
    end

  end

  context "A user that is a creator and has been assigned to a directorate that is retired" do
    setup do
      sign_in @creator = Factory(:creator)
      directorates(:directorates_retired).update_attributes!(:creator_id => @creator.id, :cops => [Factory(:user)])
    end

    should "be unable to access the Service Areas table" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the New Service Area page" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to create new Service Areas" do
      post :create
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the Edit Service Area page" do
      get :edit, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to update existing Service Areas" do
      post :update, :id => 1, :service_area => {:name => "Edited Service Area"}
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal ServiceArea.find(1).name, "Sample Service Area"
    end

    should "be unable to toggle the retired status of Service Areas" do
      post :toggle_retired_status, :id => 1, :checkbox => "retired"
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal false, ServiceArea.find(1).retired
    end

  end

  context "A user that is a creator and has been assigned to a directorate that is active" do
    setup do
      sign_in @creator = Factory(:creator)
      directorates(:directorates_001).update_attributes!(:creator_id => @creator.id, :cops => [Factory(:user)])
    end

    should "not be able to access the Service Areas table" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "not be able to access the New Service Area page" do
      get :new
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "not be able to create new Service Areas" do
      post :create, :service_area => { :name => "testarea", :approver_email => "shaun@27stars.co.uk", :retired => "0" }
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "not be able to access the Edit Service Area page" do
      get :edit, :id => 1
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "not be able to update existing Service Areas" do
      post :update, :id => 1, :service_area => {:name => "Edited Service Area"}
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "not be able to toggle the retired status of Service Areas" do
      post :toggle_retired_status, :id => 1, :checkbox => "retired"
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to access the Edit Service Area page of a Service Area that is not in their directorate" do
      get :edit, :id => 2
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

    should "be unable to updated existing Service Areas that are not in their directorate" do
      post :update, :id => 2, :service_area => {:name => "Edited Service Area"}
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal ServiceArea.find(2).name, "Sample Service Area 2"
    end

    should "be unable to toggle the retired status of Service Areas that are not in their directorate" do
      post :toggle_retired_status, :id => 2, :checkbox => "retired"
      assert_response :redirect
      assert_redirected_to access_denied_path
      assert_equal false, ServiceArea.find(2).retired
    end

    # should "be unable to create a new Service Area if it fails validation" do
    #   post :create, :service_area => { :name => "testarea", :approver_email => "!shaun@27stars.co.uk", :retired => "0" }
    #   assert_response :success
    #   assert_template :new
    #   assert_equal nil, ServiceArea.where(:name => "testarea").first
    # end

    # should "be unable to update a Service Area if it fails validation" do
    #   post :update, :id => 1, :service_area => {:name => "testarea", :approver_email => "!shaun@27.co.uk", :retired => "0"}
    #   assert_response :success
    #   assert_template :edit
    #   assert_equal nil, ServiceArea.where(:name => "testarea").first
    # end

  end

end
