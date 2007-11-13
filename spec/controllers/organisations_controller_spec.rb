require File.dirname(__FILE__) + '/../spec_helper'

describe OrganisationsController, 'routes' do

  it "should map { :controller => 'organisations', :action => 'index' } to /organisations" do
    route_for(:controller => 'organisations', :action => 'index').should == '/organisations'
  end
  
  it "should map { :controller => 'organisations', :action => 'list' } to /organisations/list" do
    route_for(:controller => 'organisations', :action => 'list').should == '/organisations/list'
  end
  
  it "should map { :controller => 'organisations', :action => 'show', :id => 1 } to /organisations/show/1" do
    route_for(:controller => 'organisations', :action => 'show', :id => 1).should == '/organisations/show/1'
  end
  
  it "should map { :controller => 'organisations', :action => 'new' } to /organisations/new" do
    route_for(:controller => 'organisations', :action => 'new').should == '/organisations/new'
  end
  
  it "should map { :controller => 'organisations', :action => 'create' } to /organisations/create" do
    route_for(:controller => 'organisations', :action => 'create').should == '/organisations/create'
  end
  
  it "should map { :controller => 'organisations', :action => 'edit', :id => 1 } to /organisations/edit/1" do
    route_for(:controller => 'organisations', :action => 'edit', :id => 1).should == '/organisations/edit/1'
  end          

  it "should map { :controller => 'organisations', :action => 'update', :id => 1 } to /organisations/update/1" do
    route_for(:controller => 'organisations', :action => 'update', :id => 1).should == '/organisations/update/1'
  end          

  it "should map { :controller => 'organisations', :action => 'destroy', :id => 1 } to /organisations/destroy/1" do
    route_for(:controller => 'organisations', :action => 'destroy', :id => 1).should == '/organisations/destroy/1'
  end          

end

describe OrganisationsController, "should not allow GET requests to dangerous actions" do
  
  before(:each) do
    login_as :organisation_manager
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

describe OrganisationsController, "should not allow access to secured actions when not logged in" do

  it "#index should not be successful" do
    get :index
    response.should be_redirect
  end
  
  it "#list should not be successful" do
    get :list
    response.should be_redirect
  end
  
  it "#show should not be successful" do
    get :show
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
  
  it "#edit should not be successful" do
    get :edit
    response.should be_redirect
  end
  
  it "#update should not be successful" do
    post :update
    response.should be_redirect
  end
  
  it "#destroy should not be successful" do
    post :destroy
    response.should be_redirect
  end
  
end

describe OrganisationsController, 'handling GET /organisations' do
  
  it "should be successful" do
    login_as :administrator
    get :index
    response.should be_success
  end
  
end

describe OrganisationsController, 'handling GET /organisations/list' do
  
  before(:each) do
    @mock_organisation_1 = mock_model(Organisation)
    @mock_organisation_1.stub!(:name).and_return('Meals on Wheels')
    @mock_organisation_2 = mock_model(Organisation)
    @mock_organisation_2.stub!(:name).and_return('Drugs and Alcohol')
    @mock_organisations = [@mock_organisation_1, @mock_organisation_2]
    Organisation.stub!(:find).and_return(@mock_organisations)
    login_as :administrator
  end
  
  it "should be successful" do
    get :list
    response.should be_success
  end
  
  it "should render 'list'" do
    get :list
    response.should render_template(:list)
  end
  
  it "should find all organisations and assign them to a variable" do
    Organisation.should_receive(:find).and_return(@mock_organisations)
    get :list
    assigns[:organisations].should eql(@mock_organisations)
  end

end

describe OrganisationsController, 'handling GET /organisations/show/:id' do
  
  before(:each) do
    @mock_organisation = mock_model(Organisation, :to_param => 1)
    @mock_user = mock_model(User)
    Organisation.stub!(:find).and_return(@mock_organisation)
    @mock_organisation.stub!(:user).and_return(@mock_user)
    login_as :administrator
  end
  
  it "should be successful" do
    get :show, :id => 1    
    response.should be_success
  end

  it "should render 'show'" do
    get :show, :id => 1
    response.should render_template(:show)
  end
  
  it "should get organisation and assign it and its user" do
    Organisation.should_receive(:find).and_return(@mock_organisation)
    get :show, :id => 1
    assigns[:organisation].should equal(@mock_organisation)
    assigns[:user].should equal(@mock_organisation.user)
  end
  
  it "should fail when given an invalid ID"

end

describe OrganisationsController, 'handling GET /organisations/new' do
  
  before(:each) do
    @mock_organisation = mock_model(Organisation)
    @mock_user = mock_model(User)
    Organisation.stub!(:new).and_return(@mock_organisation)
    User.stub!(:new).and_return(@mock_user)
    login_as :administrator
  end
  
  it "should be successful" do
    get :new    
    response.should be_success
  end
  
  it "should render 'list'" do
    get :new    
    response.should render_template(:new)
  end
  
  it "should assign a new user and organisation for the view" do
    Organisation.should_receive(:new).and_return(@mock_organisation)
    User.should_receive(:new).and_return(@mock_user)
    get :new    
    assigns[:organisation].should eql(@mock_organisation)
    assigns[:user].should eql(@mock_user)
  end

end

describe OrganisationsController, 'handling POST /organisations/create' do
  
  # TODO: fill these out
  valid_organisation_attributes = { }
  
  before(:each) do
    # Prep data
    @mock_organisation = mock_model(Organisation)
    @mock_user = mock_model(User)
    Organisation.stub!(:new).and_return(@mock_organisation)
    @mock_organisation.stub!(:build_user).and_return(@mock_user)
    @mock_user.stub!(:user_type=).and_return(User::TYPE[:organisational])
    User.stub!(:generate_passkey).and_return('f0488f7dc3f2bbb333641d6282b72fe15b3d0515')
    @mock_user.stub!(:passkey=).and_return('f0488f7dc3f2bbb333641d6282b72fe15b3d0515')
    @mock_organisation.stub!(:save!)
    
    # Authenticate
    login_as :administrator
  end
  
  it "should tell the Organisation model to create a new organisation" do
    Organisation.should_receive(:new).with(valid_organisation_attributes).and_return(@mock_organisation)
    post :create, :organisation => valid_organisation_attributes
  end
  
  it "should tell the new organisation to create a new user associated with itself" do
    @mock_organisation.should_receive(:build_user).and_return(@mock_user)
    post :create, :organisation => valid_organisation_attributes
  end
  
  it "with a valid organisation should redirect to 'organisations/list'" do
    post :create, :organisation => valid_organisation_attributes
    response.should be_redirect    
  end
  
  it "with an invalid organisation should re-render 'organisations/new'" do
    post :create
    response.should render_template(:new)
  end
  
end

describe OrganisationsController, 'handling GET /organisations/edit/:id' do
  
  before(:each) do
    @mock_organisation = mock_model(Organisation)
    @mock_user = mock_model(User)
    Organisation.stub!(:find).and_return(@mock_organisation)
    @mock_organisation.stub!(:user).and_return(@mock_user)
    login_as :administrator
  end

  it "should be successful" do
    get :edit
    response.should be_success
  end
  
  it "should render 'edit'" do
    get :edit
    response.should render_template(:edit)
  end
  
  it "should assign an existing user and organisation for the view" do
    Organisation.should_receive(:find).and_return(@mock_organisation)
    get :edit
    assigns[:organisation].should eql(@mock_organisation)
    assigns[:user].should eql(@mock_organisation.user)
  end

  it "should fail when given an invalid ID"

end

describe OrganisationsController, 'handling POST /organisations/update/:id' do
  
  it "should be successful"

end

describe OrganisationsController, 'handling POST /organisations/destroy/:id' do
  
  before(:each) do
    @mock_organisation = mock_model(Organisation, :to_param => 1)
    Organisation.stub!(:find).and_return(@mock_organisation)
    @mock_organisation.stub!(:destroy).and_return(true)
    login_as :administrator
  end
  
  it "should be successful" do
    post :destroy, :id => 1
    response.should be_redirect
  end
  
  it "should destroy the organisation" do
    @mock_organisation.should_receive(:destroy)
    post :destroy, :id => 1
  end
  
  it "should fail when given an invalid ID"

end