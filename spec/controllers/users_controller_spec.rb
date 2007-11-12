require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, "#route_for" do

end

describe UsersController, "should not allow GET requests to dangerous actions" do
    
end

describe UsersController, "should not allow access to secured actions when not logged in" do
  
end

describe UsersController, "handling GET /users/" do

  it "should be successful" do
    get :index
    response.should be_success
  end

end