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
    @organisations = [  mock_model(Organisation, :name => 'Meals on Wheels'),
                        mock_model(Organisation, :name => 'Drugs and Alcohol')
                        ]
    Organisation.stub!(:find).and_return(@organisations)
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
    Organisation.should_receive(:find).and_return(@organisations)
    get :list
    assigns[:organisations].should eql(@organisations)
  end

end

describe OrganisationsController, 'handling GET /organisations/show/:id' do
  
  before(:each) do
    @organisation = mock_model(Organisation)
    @organisation_manager = mock_model(OrganisationManager)
    Organisation.stub!(:find).and_return(@organisation)
    @organisation.stub!(:organisation_manager).and_return(@organisation_manager)
    @organisation.stub!(:directorates).and_return([])
    login_as :administrator
  end
  
  it "should be successful" do
    get :show, :id => @organisation.id
    response.should be_success
  end

  it "should render 'show'" do
    get :show, :id => @organisation.id
    response.should render_template(:show)
  end
  
  it "should get organisation and assign it and its user" do
    Organisation.should_receive(:find).and_return(@organisation)
    get :show, :id => @organisation.id
    assigns[:organisation].should equal(@organisation)
    assigns[:organisation_manager].should equal(@organisation.organisation_manager)
  end
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    get :show, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe OrganisationsController, 'handling GET /organisations/new' do
  
  before(:each) do
    @organisation = mock_model(Organisation)
    @organisation_manager = mock_model(OrganisationManager)
    Organisation.stub!(:new).and_return(@organisation)
    @organisation.stub!(:build_organisation_manager).and_return(@organisation_manager)
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
    Organisation.should_receive(:new).and_return(@organisation)
    @organisation.should_receive(:build_organisation_manager).and_return(@organisation_manager)    
    get :new    
    assigns[:organisation].should eql(@organisation)
    assigns[:organisation_manager].should eql(@organisation_manager)
  end

end

describe OrganisationsController, 'handling POST /organisations/create' do
  
  before(:each) do
    # Prep data
    @organisation = mock_model(Organisation, {  :null_object => true,
                                                :new_record? => true
                                                })
    @user = mock_model(User, :null_object => true)
    Organisation.stub!(:new).and_return(@organisation)
    @organisation.stub!(:build_organisation_manager).and_return(@user)
    # Authenticate
    login_as :administrator
  end
  
  it "should tell the Organisation model to create a new organisation" do
    Organisation.should_receive(:new).and_return(@organisation)
    post :create
  end
  
  it "should tell the new organisation to create a new user associated with itself" do
    @organisation.should_receive(:build_organisation_manager).and_return(@user)
    post :create
  end
  
  it "with a valid organisation should redirect to 'organisations/list'" do
    @organisation.stub!(:save!).and_return(nil)
    post :create
    response.should be_redirect
  end
  
  it "with an invalid organisation should re-render 'organisations/new'" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@organisation)
    @organisation.stub!(:save!).and_raise(@exception)
    post :create
    response.should render_template(:new)
  end
  
end

describe OrganisationsController, 'handling GET /organisations/edit/:id' do
  
  before(:each) do
    @organisation = mock_model(Organisation)
    @organisation_manager = mock_model(OrganisationManager)
    Organisation.stub!(:find).and_return(@organisation)
    @organisation.stub!(:organisation_manager).and_return(@organisation_manager)
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
    Organisation.should_receive(:find).and_return(@organisation)
    get :edit
    assigns[:organisation].should eql(@organisation)
    assigns[:organisation_manager].should eql(@organisation.organisation_manager)
  end

  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    get :edit, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe OrganisationsController, 'handling POST /organisations/update/:id' do
  
  before(:each) do
    # Prep data
    @organisation = mock_model(Organisation, :null_object => true)
    Organisation.stub!(:find).and_return(@organisation)
    # Authenticate
    login_as :administrator
  end

  it "should redirect to 'strategy/show/:id' with a valid strategy" do
    @organisation.stub!(:update_attributes!).and_return(nil)
    post :update
    response.should redirect_to(:action => 'show', :id => @organisation.id)
  end

  it "should assign a flash message with a valid strategy"
  
  it "should re-render 'user/edit/:id' with an invalid strategy" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@organisation)
    @organisation.stub!(:update_attributes!).and_raise(@exception)
    post :update
    response.should render_template(:edit)
  end
  
  it "should assign a flash message with an invalid strategy"  

  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    post :update, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe OrganisationsController, 'handling POST /organisations/destroy/:id' do
  
  before(:each) do
    @organisation = mock_model(Organisation)
    Organisation.stub!(:find).and_return(@organisation)
    @organisation.stub!(:destroy).and_return(true)
    login_as :administrator
  end
  
  it "should be successful" do
    post :destroy, :id => @organisation.id
    response.should be_redirect
  end
  
  it "should destroy the organisation" do
    @organisation.should_receive(:destroy)
    post :destroy, :id => @organisation.id
  end
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    post :destroy, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end