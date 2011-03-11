#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = Rails.root.to_s + '/spec/fixtures'
end

def set_referrer(url)
  request.env["HTTP_REFERER"] = url
end

def login_as(user)  
  case user
    when :activity_manager
      @activity = mock_model(Activity, {  :null_object => true,
                                          :name => 'Test activity'
                                          })
      @current_user = mock_model(ActivityManager, {  :activity => @activity
                                                     })
      User.should_receive(:find).with(@current_user.id).any_number_of_times.and_return(@current_user)
      Activity.should_receive(:find).with(@current_user.activity.id).any_number_of_times.and_return(@activity)
      request.session[:user_id] = @current_user.id
    when :organisation_manager
      @organisation = mock_model(Organisation, { :null_object => true,
                                                 :activities => []
                                                 })
      @current_user = mock_model(OrganisationManager, {  :organisation => @organisation
                                                         })
      User.should_receive(:find).with(@current_user.id).any_number_of_times.and_return(@current_user)
      Organisation.should_receive(:find).with(@current_user.organisation.id).any_number_of_times.and_return(@organisation)
      request.session[:user_id] = @current_user.id
    when :administrator
      @current_user = mock_model(Administrator)
      User.should_receive(:find).with(@current_user.id).any_number_of_times.and_return(@current_user)
      request.session[:user_id] = @current_user.id
    else
      request.session[:user_id] = nil
  end
end