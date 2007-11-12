require File.dirname(__FILE__) + '/../spec_helper'

describe FunctionsController, "#route_for" do

end

describe FunctionsController, "should not allow GET requests to dangerous actions" do
    
end

describe FunctionsController, "should not allow access to secured actions when not logged in" do
  
end

describe FunctionsController, "should show the status page if the status questions are unanswered" do
  
end

describe FunctionsController, "handling GET /functions/summary" do

  it "should be successful" do
    login_as :organisation_manager
    get :summary
    response.should be_success
  end

end