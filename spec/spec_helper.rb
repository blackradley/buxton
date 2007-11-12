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
      @mock_function = mock_model(Function, :to_param => '1')
      @mock_user = mock_model(User, { :to_param => '1',
                                      :function => @mock_function,
                                      :user_type => User::TYPE['functional']
                                      })
      User.should_receive(:find).with(@mock_user.id).any_number_of_times.and_return(@mock_user)
      request.session[:user_id] = @mock_user.id
    when :organisation_manager
      @mock_organisation = mock_model(Organisation, { :to_param => '1',
                                                      :functions => []
                                                      })
      @mock_user = mock_model(User, { :to_param => '1',
                                      :organisation => @mock_organisation,
                                      :user_type => User::TYPE['functional']
                                      })
      User.should_receive(:find).with(@mock_user.id).any_number_of_times.and_return(@mock_user)
      Organisation.should_receive(:find).with(@mock_organisation.id).any_number_of_times.and_return(@mock_organisation)
      request.session[:user_id] = @mock_user.id      
    else
      request.session[:user_id] = nil
  end
end