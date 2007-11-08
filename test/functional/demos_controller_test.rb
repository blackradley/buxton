# 
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.  
# 
require File.dirname(__FILE__) + '/../test_helper'
require 'demos_controller'

# Re-raise errors caught by the controller.
class DemosController; def rescue_action(e) raise e end; end

class DemosControllerTest < Test::Unit::TestCase
  def setup
    @controller = DemosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_get_new_page
    get :new
    assert_response :success
  end
end
