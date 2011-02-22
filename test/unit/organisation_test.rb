#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
require File.dirname(__FILE__) + '/../test_helper'

class OrganisationTest < Test::Unit::TestCase
  fixtures :users
  fixtures :organisations
#
# Check the properties of the organisation
# 
  def test_organisation_from_user
    user = OrganisationManager.find(2)
    organisation = user.organisation
    assert_equal organisations(:birmingham).name, organisation.name
    # assert_equal organisations(:birmingham).style, organisation.style
  end
#
# Ensure the validation works
# 
  def test_organisation_empty_attributes
    organisation = Organisation.new
    assert !organisation.valid?
    # assert organisation.errors.invalid?(:user)
    assert organisation.errors.invalid?(:name)
  end
end
