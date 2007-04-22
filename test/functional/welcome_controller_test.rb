#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'welcome_controller'

# Re-raise errors caught by the controller.
class WelcomeController; def rescue_action(e) raise e end; end

class WelcomeControllerTest < Test::Unit::TestCase
  def setup
    @controller = WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
