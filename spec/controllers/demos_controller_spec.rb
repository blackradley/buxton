require File.dirname(__FILE__) + '/../spec_helper'

describe DemosController, 'routes' do

  it "should map { :controller => 'demos', :action => 'new' } to /demos/new" do
    route_for(:controller => 'demos', :action => 'new').should == '/demos/new'
  end
  
  it "should map { :controller => 'demos', :action => 'create' } to /demos/create" do
    route_for(:controller => 'demos', :action => 'create').should == '/demos/create'
  end

end

describe DemosController, 'should not allow GET requests to dangerous actions' do
  
  it "#create should not be successful" do
    get :create
    response.should_not be_success
  end

end

describe DemosController, "should allow access to unsecured actions when not logged in" do

  it "#new should be successful" do
    get :new
    response.should be_success
  end

  it "#create should be successful"

end

describe DemosController, 'handling GET /demos/new' do
  
  it "should be successful" do
    get :new
    response.should be_success
  end

end

describe DemosController, 'handling POST /demos/create' do

  before do
    @organisation = mock_model(Organisation, :to_param => "1")
    Organisation.stub!(:new).and_return(@organisation)
  end  
  # 
  # def post_with_failed_save
  #   @organisation.should_receive(:save).and_raise()
  #   post :create, :user => {}
  # end

  it "should create a new demo"
  
  it "should auto-login as the new organisation manager after a successful save" do
    # @organisation.should_receive(:build_user)
    # @organisation.should_receive(:save)
    # post :create, :user => {}
    # response.should redirect_to({ :controller => 'users', :action => 'login', :passkey => '' })    
  end
  
  it "should re-render 'new' on failed save" do
    # post_with_failed_save
    # response.should render_template('new')
  end

end