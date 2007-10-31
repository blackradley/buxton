#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Our helpers
  
  # Login to the site using the passkey provided
  fixtures :users
  def login(passkey)
    old_controller = @controller
    @controller = UsersController.new
    post :login, :passkey => passkey
    
    user = User.find_by_passkey(passkey)
    case user.user_type
    when User::TYPE[:functional]
      if user.function.purpose_overall_1 != 0 && user.function.function_policy != 0 then
        assert_redirected_to :controller => 'functions', :action => 'show'
      else
       assert_redirected_to :controller => 'functions', :action => 'status'
      end
    when User::TYPE[:organisational]
      assert_redirected_to :controller => 'functions', :action => 'summary'
    when User::TYPE[:administrative]
      assert_redirected_to :controller => 'organisations', :action => 'index'
    end
    assert_not_nil session['logged_in_user']
    @controller = old_controller    
  end
end
