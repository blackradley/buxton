require File.dirname(__FILE__) + '/../spec_helper'

describe IssuesController, 'routes' do
  
  it "should map { :controller => 'issues', :action => 'create' } to /issues/create" do
    route_for(:controller => 'issues', :action => 'create').should == '/issues/create'
  end
  
  it "should map { :controller => 'issues', :action => 'update' } to /issues/update" do
    route_for(:controller => 'issues', :action => 'update').should == '/issues/update'
  end
  
  it "should map { :controller => 'issues', :action => 'destroy' } to /issues/destroy" do
    route_for(:controller => 'issues', :action => 'destroy').should == '/issues/destroy'
  end

end

describe IssuesController, 'should not allow GET requests to dangerous actions' do

  before(:each) do
    login_as :function_manager    
  end

  it "#create should not be successful" do
    get :create
    response.should_not be_success
  end

  it "#update should not be successful" do
    get :update
    response.should_not be_success
  end
  
  it "#destroy should not be successful" do
    get :destroy
    response.should_not be_success
  end

end

describe IssuesController, 'should not allow access to secured actions when not logged in' do
  
  it "#create should not be successful" do
    xhr(:post, :create)
    response.should be_redirect
  end

  it "#update should not be successful" do
    post :update
    response.should be_redirect
  end
  
  it "#destroy should not be successful" do
    xhr(:post, :destroy)
    response.should be_redirect
  end

end

describe IssuesController, 'handling POST /issues/create' do
  
  before(:each) do
    login_as :function_manager
    @issue = mock_model(Issue)
    Issue.stub!(:new).and_return(@issue)
  end
  
  def xhr_post_with_successful_save
    @issue.should_receive(:save).and_return(true)
    xhr(:post, :create, :issue => {})
  end
  
  def xhr_post_with_failed_save
    @issue.should_receive(:save).and_return(false)
    xhr(:post, :create, :issue => {})
  end  

  it "should create a new issue" do
    Issue.should_receive(:new).with({}).and_return(@issue)
    xhr_post_with_successful_save
  end
  
  it "should render new issue with RJS if successful"
  
  it "should render error with RJS on failed save"

end

describe IssuesController, 'handling POST /issues/update/:id' do

  it "should find the issue requested"
  
  it "should update the found issue"
  
  it "should redirect backwards on a successful save"

  it "should show a 404 page if the issue could not be found"

end

describe IssuesController, 'handling POST /issues/destroy/:id' do

  it "should find the issue requested"
  
  it "should call destroy on the found issue"
  
  it "should render RJS to remove the issue from the view"
  
  it "should show a 404 page if the issue could not be found"

end