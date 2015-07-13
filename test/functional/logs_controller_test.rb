require 'test_helper'

class LogsControllerTest < ActionController::TestCase

  context "when not a cop" do
    setup do
      sign_in Factory(:user)
    end

    should "not be able to access the logs" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

  end

  context "when anyone but a corporate cop" do
    setup do
      @user = Factory(:creator)
      Factory(:activity, :completer => @user, :approver =>  Factory(:user), :qc_officer => Factory(:user))
      Factory(:activity, :completer => Factory(:user), :approver =>  @user, :qc_officer => Factory(:user))
      Factory(:activity, :completer => Factory(:user), :approver =>  Factory(:user), :qc_officer => @user)
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
      sign_in Factory(:administrator)
    end

    should "not be able to access the logs" do
      get :index
      assert_response :redirect
      assert_redirected_to access_denied_path
    end

  end

  context "When a corporate cop" do
    setup do
      sign_in Factory(:corporate_cop)
    end

    should "be able to access the logs" do
      get :index
      assert_response :success
    end

  end

end
