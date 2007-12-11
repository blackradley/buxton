require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, 'routes' do

  it "should map { :controller => 'users', :action => 'index' } to /users" do
    route_for(:controller => 'users', :action => 'index').should == '/'
  end
  
  it "should map { :controller => 'users', :action => 'list' } to /users/list" do
    route_for(:controller => 'users', :action => 'list').should == '/users/list'
  end
  
  it "should map { :controller => 'users', :action => 'new' } to /users/new" do
    route_for(:controller => 'users', :action => 'new').should == '/users/new'
  end
  
  it "should map { :controller => 'users', :action => 'create' } to /users/create" do
    route_for(:controller => 'users', :action => 'create').should == '/users/create'
  end
  
  it "should map { :controller => 'users', :action => 'edit', :id => 1 } to /users/edit/1" do
    route_for(:controller => 'users', :action => 'edit', :id => 1).should == '/users/edit/1'
  end  

  it "should map { :controller => 'users', :action => 'update', :id => 1 } to /users/update/1" do
    route_for(:controller => 'users', :action => 'update', :id => 1).should == '/users/update/1'
  end

  it "should map { :controller => 'users', :action => 'new_link' } to /users/new_link" do
    route_for(:controller => 'users', :action => 'new_link').should == '/users/new_link'
  end
  
  it "should map { :controller => 'users', :action => 'destroy', :id => 1 } to /users/destroy/1" do
    route_for(:controller => 'users', :action => 'destroy', :id => 1).should == '/users/destroy/1'
  end  

  it "should map { :controller => 'users', :action => 'remind', :id => 1 } to /users/remind/1" do
    route_for(:controller => 'users', :action => 'remind', :id => 1).should == '/users/remind/1'
  end
  
  it "should map { :controller => 'users', :action => 'login' } to /users/login" do
    route_for(:controller => 'users', :action => 'login').should == '/users/login'
  end
  
  it "should map { :controller => 'users', :action => 'login', :passkey => 'f0488f7dc3f2bbb333641d6282b72fe15b3d0515' } to /f0488f7dc3f2bbb333641d6282b72fe15b3d0515" do
    route_for(:controller => 'users', :action => 'login', :passkey => 'f0488f7dc3f2bbb333641d6282b72fe15b3d0515').should == '/f0488f7dc3f2bbb333641d6282b72fe15b3d0515'
  end  

end

describe UsersController, "should not allow GET requests to dangerous actions" do

  before(:each) do
    login_as :administrator
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

describe UsersController, "should allow access to unsecured actions when not logged in" do

  it "#index should be successful" do
    get :index
    response.should be_success
  end

  it "#new_link should be successful" do
    post :new_link
    response.should be_redirect
  end
  
  it "#login should be successful" do
    get :login
    response.should be_redirect
  end

end

describe UsersController, "should not allow access to secured actions when not logged in" do
  
  it "#list should not be successful"
  
  it "#new should not be successful"
  
  it "#create should not be successful"
  
  it "#edit should not be successful"
  
  it "#update should not be successful"
  
  it "#destroy should not be successful"
  
  it "#remind should not be successful"
  
end

describe UsersController, "handling GET /users/" do

  it "should be successful" do
    get :index
    response.should be_success
  end

end

describe UsersController, 'handling GET /users/list' do
  
  it "should be successful" do
    get :list
    response.should be_success
  end

end

describe UsersController, 'handling GET /users/new' do
  
  it "should be successful" do
    get :new
    response.should be_success
  end

end

describe UsersController, 'handling POST /users/create' do
  
  before(:each) do
    # Prep data
    @administrator = mock_model(Administrator, :null_object => true)
    Administrator.stub!(:new).and_return(@administrator)    
    # Authenticate
    login_as :administrator
  end

  it "should redirect to 'users/list' with a valid user" do
    @administrator.stub!(:save!).and_return(nil)
    post :create
    response.should redirect_to(:action => 'list')
  end

  it "should assign a flash message with a valid user"
  
  it "should render 'users/new' with an invalid user" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@administrator)
    @administrator.stub!(:save!).and_raise(@exception)
    post :create
    response.should render_template(:new)
  end
  
  it "should assign a flash message with an invalid user"  

end

describe UsersController, 'handling GET /users/edit/:id' do
  
  # it "should be successful" do
  #   get :edit, :id => 2
  #   response.should be_success
  # end

  it "should fail when given an invalid ID"

end

describe UsersController, 'handling POST /users/update/:id' do
  
  before(:each) do
    # Prep data
    @administrator = mock_model(Administrator, :null_object => true)
    Administrator.stub!(:find).and_return(@administrator)    
    # Authenticate
    login_as :administrator
  end

  it "should redirect to 'user/list' with a valid activity" do
    @administrator.stub!(:update_attributes!).and_return(nil)
    post :update
    response.should redirect_to(:action => 'list')
  end

  it "should assign a flash message with a valid activity"
  
  it "should re-render 'user/edit/:id' with an invalid activity" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@administrator)
    @administrator.stub!(:update_attributes!).and_raise(@exception)
    post :update
    response.should render_template(:edit)
  end
  
  it "should assign a flash message with an invalid activity"  

  it "should fail when given an invalid ID"

end

describe UsersController, 'handling POST /users/new_link' do
  
  it "should be successful"

end

describe UsersController, 'handling POST /users/destroy/:id' do
  
  before(:each) do
    @administrator = mock_model(Administrator)
    Administrator.stub!(:find).and_return(@administrator)
    @administrator.stub!(:destroy).and_return(true)
  end
  
  it "should be successful" do
    post :destroy, :id => @administrator.id
    response.should be_redirect
  end
  
  it "should destroy the organisation" do
    @administrator.should_receive(:destroy)
    post :destroy, :id => @administrator.id
  end
  
  it "should fail when given an invalid ID"

end

describe UsersController, 'login procedure' do
  
  it "should be successful"

end