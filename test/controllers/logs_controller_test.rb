require 'test_helper'

class LogsControllerTest < ActionController::TestCase

  context "when not a cop" do
    setup do
      sign_in FactoryGirl.create(:user)
    end

    should "not be able to access the logs" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

  end

  context "when anyone but a corporate cop" do
    setup do
      @user = FactoryGirl.create(:creator)
      FactoryGirl.create(:activity, :completer => @user, :approver =>  FactoryGirl.create(:user), :qc_officer => FactoryGirl.create(:user))
      FactoryGirl.create(:activity, :completer => FactoryGirl.create(:user), :approver =>  @user, :qc_officer => FactoryGirl.create(:user))
      FactoryGirl.create(:activity, :completer => FactoryGirl.create(:user), :approver =>  FactoryGirl.create(:user), :qc_officer => @user)
      sign_in @user
    end

    should "not be able to access the logs" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

  end

  context "When an admin" do
    setup do
      sign_in FactoryGirl.create(:administrator)
    end

    should "not be able to access the logs" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

  end

  context "When a corporate cop" do
    setup do
      sign_in FactoryGirl.create(:corporate_cop)
    end

    should "be able to access the logs" do
      get :index
      assert_response :success
    end

  end

end
