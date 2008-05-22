#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'

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
  def login_as(user_type)
    old_controller = @controller
    @controller = UsersController.new
    case user_type
    when :activity_manager
      user = ActivityManager.find(3)
      post :login, :passkey => user.passkey
      if user.function.started then
        assert_redirected_to :controller => 'functions', :action => 'show'
      else
       assert_redirected_to :controller => 'functions', :action => 'status'
      end
    when :organisation_manager
      user = OrganisationManager.find(2)
      post :login, :passkey => user.passkey
      assert_redirected_to :controller => 'functions', :action => 'summary'
    when :administrator
      user = Administrator.find(1)
      post :login, :passkey => user.passkey      
      assert_redirected_to :controller => 'organisations', :action => 'index'
    end
    assert_not_nil session[:user_id]
    @controller = old_controller    
  end
  
  def url_for(options)
    url = ActionController::UrlRewriter.new(@request, nil)
    url.rewrite(options)
  end  
end
