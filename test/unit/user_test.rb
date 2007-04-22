#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users
#
# Check the properties of the third user (me).
# 
  def test_third_user
    @user = User.find(3)
    assert_equal @user.email, users(:three).email
    assert_equal @user.user_type, User::ADMINISTRATIVE
  end
#
# Get the admin users
#  
  def test_administrative_user
    @users = User.find_all_by_email(users(:three).email)
    assert_equal @users.length, 1
    @user = @users.first
    assert_equal @user.email, users(:three).email
    assert_equal @user.user_type, User::ADMINISTRATIVE
  end
#
# Get a user based on the passkey
#
 def test_find_by_passkey
   @user = User.find_by_passkey('72fde67c-368f-102a-b437-080046905aee')
    assert_equal @user.email, users(:three).email
    assert_equal @user.user_type, User::ADMINISTRATIVE
 end
end
