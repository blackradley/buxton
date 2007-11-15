# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures'
end

def login_as(user)  
  case user
    when :function_manager
      @function = mock_model(Function, :to_param => '1')
      @current_user = mock_model(FunctionManager, {  :to_param => '1',
                                                     :function => @function,
                                                     })
      User.should_receive(:find).with(@current_user.id).any_number_of_times.and_return(@current_user)
      Function.should_receive(:find).with(@current_user.function.id).any_number_of_times.and_return(@function)      
      request.session[:user_id] = @current_user.id
    when :organisation_manager
      @organisation = mock_model(Organisation, { :to_param => '1',
                                                 :functions => []
                                                 })
      @current_user = mock_model(OrganisationManager, {  :to_param => '1',
                                                         :organisation => @organisation,
                                                         })
      User.should_receive(:find).with(@current_user.id).any_number_of_times.and_return(@current_user)
      Organisation.should_receive(:find).with(@current_user.organisation.id).any_number_of_times.and_return(@organisation)      
      request.session[:user_id] = @current_user.id
    when :administrator
      @current_user = mock_model(Administrator, { :to_param => '1' })
      User.should_receive(:find).with(@current_user.id).any_number_of_times.and_return(@current_user)
      request.session[:user_id] = @current_user.id
    else
      request.session[:user_id] = nil
  end
end