ENV["RAILS_ENV"] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path('../../test/factory', __FILE__)

class ActionController::TestCase
  include Devise::TestHelpers

  # self.use_transactional_fixtures = true

  # self.use_instantiated_fixtures  = true

  fixtures :all

  def json_response
      ActiveSupport::JSON.decode @response.body
  end
end
