#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users
#
# Check the properties of the administrative user.
# 
  def test_administrative
    user = Administrator.find(1)
    assert_equal users(:administrator).email, user.email
  end
#
# Check the properties of the organisational user.
#  
  def test_organisational
    user = OrganisationManager.find(2)
    assert_equal users(:organisation_manager).email, user.email 
  end
#
# Check the properties of the functional user.
#  
  def test_functional
    user = FunctionManager.find(3)
    assert_equal users(:function_manager).email, user.email
  end
#
# Find by functional users by email 
#
  def test_find_all_by_email
    users = User.find_all_by_email(users(:function_manager).email)
    assert_equal users.length, 1
    user = users.first
    assert_equal users(:function_manager).email, user.email
    assert_equal 'FunctionManager', user.type
  end
#
# Get the admin users
#  
  def test_find_admins
    admins = Administrator.find(:all)
    assert_equal admins.length, 1
    admin = admins.first
    assert_equal users(:administrator).email, admin.email
  end
#
# Get a user based on the passkey
#
  def test_find_by_passkey
    user = User.find_by_passkey('5b550821be4aa80e4fefd672722c236a109e8abd')
    assert_equal user.email, users(:organisation_manager).email
  end
end
