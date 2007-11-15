require File.dirname(__FILE__) + '/../spec_helper'

describe SectionsController, 'routes' do

  it "should map { :controller => 'sections', :action => 'list', :id => 'purpose' } to /sections/list/purpose" do
    route_for(:controller => 'sections', :action => 'list', :id => 'purpose').should == '/sections/list/purpose'
  end

  it "should map { :controller => 'sections', :action => 'list', :id => 'performance' } to /sections/list/performance" do
    route_for(:controller => 'sections', :action => 'list', :id => 'performance').should == '/sections/list/performance'
  end
  
  it "should map { :controller => 'sections', :action => 'list', :id => 'confidence_information' } to /sections/list/confidence_information" do
    route_for(:controller => 'sections', :action => 'list', :id => 'confidence_information').should == '/sections/list/confidence_information'
  end  

  it "should map { :controller => 'sections', :action => 'list', :id => 'confidence_consultation' } to /sections/list/confidence_consultation" do
    route_for(:controller => 'sections', :action => 'list', :id => 'confidence_consultation').should == '/sections/list/confidence_consultation'
  end

  it "should map { :controller => 'sections', :action => 'list', :id => 'additional_work' } to /sections/list/additional_work" do
    route_for(:controller => 'sections', :action => 'list', :id => 'additional_work').should == '/sections/list/additional_work'
  end
  
  it "should map { :controller => 'sections', :action => 'list', :id => 'action_planning' } to /sections/list/action_planning" do
    route_for(:controller => 'sections', :action => 'list', :id => 'action_planning').should == '/sections/list/action_planning'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'purpose' } to /sections/show/purpose" do
    route_for(:controller => 'sections', :action => 'show', :id => 'purpose').should == '/sections/show/purpose'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'performance' } to /sections/show/performance" do
    route_for(:controller => 'sections', :action => 'show', :id => 'performance').should == '/sections/show/performance'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_information' } to /sections/show/confidence_information" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_information').should == '/sections/show/confidence_information'
  end  

  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_consultation' } to /sections/show/confidence_consultation" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_consultation').should == '/sections/show/confidence_consultation'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'additional_work' } to /sections/show/additional_work" do
    route_for(:controller => 'sections', :action => 'show', :id => 'additional_work').should == '/sections/show/additional_work'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'action_planning' } to /sections/show/action_planning" do
    route_for(:controller => 'sections', :action => 'show', :id => 'action_planning').should == '/sections/show/action_planning'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'purpose', :f => 1 } to /sections/show/purpose?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'purpose', :f => 1).should == '/sections/show/purpose?f=1'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'performance', :f => 1 } to /sections/show/performance?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'performance', :f => 1).should == '/sections/show/performance?f=1'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_information', :f => 1 } to /sections/show/confidence_information?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_information', :f => 1).should == '/sections/show/confidence_information?f=1'
  end  

  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_consultation', :f => 1 } to /sections/show/confidence_consultation?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_consultation', :f => 1).should == '/sections/show/confidence_consultation?f=1'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'additional_work', :f => 1 } to /sections/show/additional_work?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'additional_work', :f => 1).should == '/sections/show/additional_work?f=1'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'action_planning', :f => 1 } to /sections/show/action_planning?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'action_planning', :f => 1).should == '/sections/show/action_planning?f=1'
  end

  it "should map the various edit variances"

  it "should map { :controller => 'sections', :action => 'update' } to /sections/update" do
    route_for(:controller => 'sections', :action => 'update').should == '/sections/update'
  end

end

describe SectionsController, "should not allow GET requests to dangerous actions" do

  it "#update should not be successful" do
    login_as :function_manager
    get :update
    response.should_not be_success
  end
    
end

describe SectionsController, "should not allow access to secured actions when not logged in" do

  it "#list should not be successful" do
    get :list
    response.should be_redirect
  end
  
  it "#show should not be successful" do
    get :show
    response.should be_redirect
  end
  
  it "#edit should not be successful" do
    get :edit
    response.should be_redirect
  end
  
  it "#update should not be successful" do
    post :update
    response.should be_redirect
  end
        
end

describe SectionsController, 'handling GET /sections/list/:id' do
  
  before(:each) do
    login_as :organisation_manager
  end

  it "should be successful with 'purpose'" do
    get :list, :id => 'purpose'
    response.should be_success
  end
  
  it "should be successful with 'performance'" do
    get :list, :id => 'performance'
    response.should be_success
  end

  it "should be successful with 'confidence_information'" do
    get :list, :id => 'confidence_information'
    response.should be_success
  end
  
  it "should be successful with 'confidence_consultation'" do
    get :list, :id => 'confidence_consultation'
    response.should be_success
  end
  
  it "should be successful with 'additional_work'" do
    get :list, :id => 'additional_work'
    response.should be_success
  end
  
  it "should be successful with 'action_planning'" do
    get :list, :id => 'action_planning'
    response.should be_success
  end

  it "should be unsuccessful with an invalid section" do
    get :list, :id => 'asdasdaadas'
    response.should_not be_success
  end

end

describe SectionsController, 'handling GET /sections/show/:id' do
  
  before(:each) do
    login_as :function_manager
    @function = @current_user.function
    @function.stub!(:started).and_return(true)
    @function.stub!(:function_strategies).and_return([])    
  end

  it "should be successful with 'purpose'" do
    get :show, :id => 'purpose'
    response.should be_success
  end
  
  it "should be successful with 'performance'" do
    get :show, :id => 'performance'
    response.should be_success
  end

  it "should be successful with 'confidence_information'" do
    get :show, :id => 'confidence_information'
    response.should be_success
  end
  
  it "should be successful with 'confidence_consultation'" do
    get :show, :id => 'confidence_consultation'
    response.should be_success
  end
  
  it "should be successful with 'additional_work'" do
    get :show, :id => 'additional_work'
    response.should be_success
  end
  
  it "should be successful with 'action_planning'" do
    get :show, :id => 'action_planning'
    response.should be_success
  end

end

describe SectionsController, 'handling GET /sections/edit/:id/:equality_strand' do
  
  it "should be successful"

end

describe SectionsController, 'handling POST /sections/update' do
  
  it "should be successful"

end