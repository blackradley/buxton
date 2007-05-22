#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'
require 'demonstration_controller'

# Re-raise errors caught by the controller.
class DemonstrationController; def rescue_action(e) raise e end; end

class DemonstrationControllerTest < Test::Unit::TestCase
  def setup
    @controller = DemonstrationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
