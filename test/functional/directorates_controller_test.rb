#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
require File.dirname(__FILE__) + '/../test_helper'
require 'directorates_controller'

# Re-raise errors caught by the controller.
class DirectoratesController; def rescue_action(e) raise e end; end

class DirectoratesControllerTest < Test::Unit::TestCase
  def setup
    @controller = DirectoratesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end