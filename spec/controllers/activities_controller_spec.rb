require File.dirname(__FILE__) + '/../spec_helper'

describe ActivitiesController, 'routes' do
  
  it "should map { :controller => 'activities', :action => 'index' } to /activities" do
    route_for(:controller => 'activities', :action => 'index').should == '/activities'
  end

  it "should map { :controller => 'activities', :action => 'summary' } to /activities/summary" do
    route_for(:controller => 'activities', :action => 'summary').should == '/activities/summary'
  end
  
  it "should map { :controller => 'activities', :action => 'show' } to /activities/show" do
    route_for(:controller => 'activities', :action => 'show').should == '/activities/show'
  end

  it "should map { :controller => 'activities', :action => 'overview' } to /activities/overview" do
    route_for(:controller => 'activities', :action => 'overview').should == '/activities/overview'
  end

  it "should map { :controller => 'activities', :action => 'list' } to /activities/list" do
    route_for(:controller => 'activities', :action => 'list').should == '/activities/list'
  end

  it "should map { :controller => 'activities', :action => 'new' } to /activities/new" do
    route_for(:controller => 'activities', :action => 'new').should == '/activities/new'
  end
    
  it "should map { :controller => 'activities', :action => 'create' } to /activities/create" do
    route_for(:controller => 'activities', :action => 'create').should == '/activities/create'
  end

  it "should map { :controller => 'activities', :action => 'update' } to /activities/update" do
    route_for(:controller => 'activities', :action => 'update').should == '/activities/update'
  end

  it "should map { :controller => 'activities', :action => 'status' } to /activities/status" do
    route_for(:controller => 'activities', :action => 'status').should == '/activities/status'
  end
  
  it "should map { :controller => 'activities', :action => 'update_status' } to /activities/update_status" do
    route_for(:controller => 'activities', :action => 'update_status').should == '/activities/update_status'
  end
  
  it "should map { :controller => 'activities', :action => 'edit_contact', :id => 1 } to /activities/edit_contact/1" do
    route_for(:controller => 'activities', :action => 'edit_contact', :id => 1).should == '/activities/edit_contact/1'
  end

  it "should map { :controller => 'activities', :action => 'update_contact', :id => 1 } to /activities/update_contact/1" do
    route_for(:controller => 'activities', :action => 'update_contact', :id => 1).should == '/activities/update_contact/1'
  end

  it "should map { :controller => 'activities', :action => 'destroy', :id => 1 } to /activities/destroy/1" do
    route_for(:controller => 'activities', :action => 'destroy', :id => 1).should == '/activities/destroy/1'
  end
  
  it "should map { :controller => 'activities', :action => 'print' } to /activities/print" do
    route_for(:controller => 'activities', :action => 'print').should == '/activities/print'
  end

end

describe ActivitiesController, "should not allow GET requests to dangerous actions" do

  it "#create should not be successful" do
    login_as :organisation_manager
    get :create
    response.should_not be_success
  end

  it "#update should not be successful" do
    login_as :activities_manager
    get :update
    response.should_not be_success
  end

  it "#update_contact should not be successful" do
    login_as :organisation_manager
    get :update_contact
    response.should_not be_success
  end
  
  it "#update_status should not be successful" do
    login_as :activities_manager
    get :update_status
    response.should_not be_success
  end
  
  it "#destroy should not be successful" do
    login_as :organisation_manager
    get :destroy
    response.should_not be_success
  end  
    
end

describe ActivitiesController, "should not allow access to secured actions when not logged in" do
  
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

describe ActivitiesController, 'handling GET /activities' do
  
  it "should be successful"

end

describe ActivitiesController, "handling GET /activities/summary" do

  it "should be successful" do
    login_as :organisation_manager
    get :summary
    response.should be_success
  end
  
  it "should not allow access to a activities manager"
  
  it "should not allow access to an administrator"  

end

describe ActivitiesController, "handling GET /activities/show" do

  it "should be successful" do
    login_as :activities_manager
    get :show
    response.should be_success
  end
  
end

describe ActivitiesController, "handling GET /activities/overview" do

  it "should be successful" do
    login_as :activities_manager
    get :overview
    response.should be_success
  end
  
end

describe ActivitiesController, "handling GET /activities/list" do

  it "should be successful" do
    login_as :organisation_manager
    get :list
    response.should be_success
  end
  
end

describe ActivitiesController, "handling GET /activities/new" do

  it "should be successful" do
    login_as :organisation_manager
    get :new
    response.should be_success
  end
  
end

describe ActivitiesController, "handling POST /activities/create" do

  before(:each) do
    # Prep data
    @activities = mock(:activities, :null_object => true)
    @activities_manager = mock(:activities_manager, :null_object => true)
    @activities.stub!(:new_record?).and_return(true)
    @activities.stub!(:build_activities_manager).and_return(@activities_manager)
    # Authenticate
    login_as :organisation_manager    
    @current_user.organisation.stub!(:activities).and_return([])
    @current_user.organisation.activities.stub!(:build).and_return(@activities)
  end

  it "should tell the Function model to create a new activities" do
    @current_user.organisation.activities.should_receive(:build).and_return(@activities)
    post :create
  end
  
  it "should tell the new activities to create a new user associated with itself" do
    @activities.should_receive(:build_activities_manager).and_return(@activities_manager)
    post :create
  end
  
  it "with a valid activities should redirect to 'activities/list'" do
    @activities.stub!(:save!).and_return(nil)
    post :create
    response.should be_redirect
  end
  
  it "with an invalid activities should re-render 'activities/new'" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@activities)
    @activities.stub!(:save!).and_raise(@exception)
    post :create
    response.should render_template(:new)
  end
  
end

describe ActivitiesController, "handling POST /activities/update" do

  it "should be successful"
  
end

describe ActivitiesController, "handling GET /activities/status" do
  
  it "should be successful" do
    login_as :activities_manager
    get :status
    response.should be_success
  end
  
  it "should re-show the status page if the status questions remain unanswered"

  it "should not allow access to an organisation manager"
  
  it "should not allow access to an administrator"
  
end

describe ActivitiesController, "handling POST /activities/update_status" do

  it "should be successful"
  
end

describe ActivitiesController, "handling GET /activities/edit_contact/:id" do

  it "should be successful" do
    # login_as :organisation_manager
    # get :edit_contact, :id => 1
    # response.should be_success
  end
  
  it "should fail when given an invalid ID"  
  
end

describe ActivitiesController, "handling POST /activities/update_contact/:id" do

  it "should be successful"
  
  it "should fail when given an invalid ID"  
  
end

describe ActivitiesController, "handling POST /activities/destroy/:id" do

  before(:each) do
    @activities = mock_model(Function, :to_param => 2)
    Function.stub!(:find).and_return(@activities)
    @activities.stub!(:destroy).and_return(true)
    login_as :organisation_manager
  end
  
  it "should be successful" do
    post :destroy, :id => 2
    response.should be_redirect
  end
  
  it "should destroy the organisation" do
    @activities.should_receive(:destroy)
    post :destroy, :id => 2
  end
  
  it "should fail when given an invalid ID"
  
end

describe ActivitiesController, "handling GET /activities/print" do

  it "should be successful"
  
end