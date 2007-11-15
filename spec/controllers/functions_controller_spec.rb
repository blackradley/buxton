require File.dirname(__FILE__) + '/../spec_helper'

describe FunctionsController, 'routes' do
  
  it "should map { :controller => 'functions', :action => 'index' } to /functions" do
    route_for(:controller => 'functions', :action => 'index').should == '/functions'
  end

  it "should map { :controller => 'functions', :action => 'summary' } to /functions/summary" do
    route_for(:controller => 'functions', :action => 'summary').should == '/functions/summary'
  end
  
  it "should map { :controller => 'functions', :action => 'show' } to /functions/show" do
    route_for(:controller => 'functions', :action => 'show').should == '/functions/show'
  end

  it "should map { :controller => 'functions', :action => 'overview' } to /functions/overview" do
    route_for(:controller => 'functions', :action => 'overview').should == '/functions/overview'
  end

  it "should map { :controller => 'functions', :action => 'list' } to /functions/list" do
    route_for(:controller => 'functions', :action => 'list').should == '/functions/list'
  end

  it "should map { :controller => 'functions', :action => 'new' } to /functions/new" do
    route_for(:controller => 'functions', :action => 'new').should == '/functions/new'
  end
    
  it "should map { :controller => 'functions', :action => 'create' } to /functions/create" do
    route_for(:controller => 'functions', :action => 'create').should == '/functions/create'
  end

  it "should map { :controller => 'functions', :action => 'update' } to /functions/update" do
    route_for(:controller => 'functions', :action => 'update').should == '/functions/update'
  end

  it "should map { :controller => 'functions', :action => 'status' } to /functions/status" do
    route_for(:controller => 'functions', :action => 'status').should == '/functions/status'
  end
  
  it "should map { :controller => 'functions', :action => 'update_status' } to /functions/update_status" do
    route_for(:controller => 'functions', :action => 'update_status').should == '/functions/update_status'
  end
  
  it "should map { :controller => 'functions', :action => 'edit_contact', :id => 1 } to /functions/edit_contact/1" do
    route_for(:controller => 'functions', :action => 'edit_contact', :id => 1).should == '/functions/edit_contact/1'
  end

  it "should map { :controller => 'functions', :action => 'update_contact', :id => 1 } to /functions/update_contact/1" do
    route_for(:controller => 'functions', :action => 'update_contact', :id => 1).should == '/functions/update_contact/1'
  end

  it "should map { :controller => 'functions', :action => 'destroy', :id => 1 } to /functions/destroy/1" do
    route_for(:controller => 'functions', :action => 'destroy', :id => 1).should == '/functions/destroy/1'
  end
  
  it "should map { :controller => 'functions', :action => 'print' } to /functions/print" do
    route_for(:controller => 'functions', :action => 'print').should == '/functions/print'
  end

end

describe FunctionsController, "should not allow GET requests to dangerous actions" do

  it "#create should not be successful" do
    login_as :organisation_manager
    get :create
    response.should_not be_success
  end

  it "#update should not be successful" do
    login_as :function_manager
    get :update
    response.should_not be_success
  end

  it "#update_contact should not be successful" do
    login_as :organisation_manager
    get :update_contact
    response.should_not be_success
  end
  
  it "#update_status should not be successful" do
    login_as :function_manager
    get :update_status
    response.should_not be_success
  end
  
  it "#destroy should not be successful" do
    login_as :organisation_manager
    get :destroy
    response.should_not be_success
  end  
    
end

describe FunctionsController, "should not allow access to secured actions when not logged in" do
  
  it "#index should not be successful" do
    get :index
    response.should be_redirect
  end
  
  it "#summary should not be successful" do
    get :summary
    response.should be_redirect
  end
  
  it "#show should not be successful" do
    get :show
    response.should be_redirect
  end
  
  it "#overview should not be successful" do
    get :overview
    response.should be_redirect
  end
  
  it "#list should not be successful" do
    get :list
    response.should be_redirect
  end
  
  it "#new should not be successful" do
    get :new
    response.should be_redirect
  end

  it "#create should not be successful" do
    post :create
    response.should be_redirect
  end

  it "#update should not be successful" do
    post :update
    response.should be_redirect
  end
  
  it "#update_status should not be successful" do
    post :update_status
    response.should be_redirect
  end
  
  it "#edit_contact should not be successful" do
    get :edit_contact
    response.should be_redirect
  end
  
  it "#update_contact should not be successful" do
    post :update_contact
    response.should be_redirect
  end
  
  it "#destroy should not be successful" do
    post :destroy
    response.should be_redirect
  end
  
  it "#print should not be successful" do
    get :print
    response.should be_redirect
  end
  
end

describe FunctionsController, 'handling GET /functions' do
  
  it "should be successful"

end

describe FunctionsController, "handling GET /functions/summary" do

  it "should be successful" do
    login_as :organisation_manager
    get :summary
    response.should be_success
  end
  
  it "should not allow access to a function manager"
  
  it "should not allow access to an administrator"  

end

describe FunctionsController, "handling GET /functions/show" do

  it "should be successful" do
    login_as :function_manager
    get :show
    response.should be_success
  end
  
end

describe FunctionsController, "handling GET /functions/overview" do

  it "should be successful" do
    login_as :function_manager
    get :overview
    response.should be_success
  end
  
end

describe FunctionsController, "handling GET /functions/list" do

  it "should be successful" do
    login_as :organisation_manager
    get :list
    response.should be_success
  end
  
end

describe FunctionsController, "handling GET /functions/new" do

  it "should be successful" do
    login_as :organisation_manager
    get :new
    response.should be_success
  end
  
end

describe FunctionsController, "handling POST /functions/create" do

  before(:each) do
    # Prep data
    @function = mock(:function, :null_object => true)
    @function_manager = mock(:function_manager, :null_object => true)
    @function.stub!(:new_record?).and_return(true)
    @function.stub!(:build_function_manager).and_return(@function_manager)
    # Authenticate
    login_as :organisation_manager    
    @current_user.organisation.stub!(:functions).and_return([])
    @current_user.organisation.functions.stub!(:build).and_return(@function)
  end

  it "should tell the Function model to create a new function" do
    @current_user.organisation.functions.should_receive(:build).and_return(@function)
    post :create
  end
  
  it "should tell the new function to create a new user associated with itself" do
    @function.should_receive(:build_function_manager).and_return(@function_manager)
    post :create
  end
  
  it "with a valid function should redirect to 'functions/list'" do
    @function.stub!(:save!).and_return(nil)
    post :create
    response.should be_redirect
  end
  
  it "with an invalid function should re-render 'functions/new'" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@function)
    @function.stub!(:save!).and_raise(@exception)
    post :create
    response.should render_template(:new)
  end
  
end

describe FunctionsController, "handling POST /functions/update" do

  it "should be successful"
  
end

describe FunctionsController, "handling GET /functions/status" do
  
  it "should be successful" do
    login_as :function_manager
    get :status
    response.should be_success
  end
  
  it "should re-show the status page if the status questions remain unanswered"

  it "should not allow access to an organisation manager"
  
  it "should not allow access to an administrator"
  
end

describe FunctionsController, "handling POST /functions/update_status" do

  it "should be successful"
  
end

describe FunctionsController, "handling GET /functions/edit_contact/:id" do

  it "should be successful" do
    # login_as :organisation_manager
    # get :edit_contact, :id => 1
    # response.should be_success
  end
  
end

describe FunctionsController, "handling POST /functions/update_contact/:id" do

  it "should be successful"
  
end

describe FunctionsController, "handling POST /functions/destroy/:id" do

  before(:each) do
    @function = mock_model(Function, :to_param => 2)
    Function.stub!(:find).and_return(@function)
    @function.stub!(:destroy).and_return(true)
    login_as :organisation_manager
  end
  
  it "should be successful" do
    post :destroy, :id => 2
    response.should be_redirect
  end
  
  it "should destroy the organisation" do
    @function.should_receive(:destroy)
    post :destroy, :id => 2
  end
  
  it "should fail when given an invalid ID"
  
end

describe FunctionsController, "handling GET /functions/print" do

  it "should be successful"
  
end