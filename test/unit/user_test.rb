#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @user = users(:three)
  end

  # Replace this with your real tests.
  def test_first_user
    assert_equal @user.email, 'drbollins@hotmail.com'
  end
end
