#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
require File.dirname(__FILE__) + '/../test_helper'

class LookUpTest < Test::Unit::TestCase
  fixtures :look_ups

  # Replace this with your real tests.
  def test_agree_disagree
    @agree_disagree = LookUp.agree_disagree
    assert_equal(LookUp.count, 5)
    assert_equal(@agree_disagree.length, 5)
    assert_equal(@agree_disagree[0].name, "Disagree strongly")
  end
end
