#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'

class FunctionTest < Test::Unit::TestCase
  fixtures :users
  fixtures :functions
#
# Check the properties of the organisation
# 
  def test_function_from_user
    user = User.find(3)
    function = user.function
    assert_equal functions(:meals_on_wheels).name, function.name
  end
#
# Ensure the validation works
#
  def test_function_empty_attributes
    function = Function.new
    assert !function.valid?
    assert function.errors.invalid?(:user)
    assert function.errors.invalid?(:name)
  end
end
