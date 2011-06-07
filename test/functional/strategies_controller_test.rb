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
  
end