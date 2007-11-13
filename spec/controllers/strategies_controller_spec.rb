require File.dirname(__FILE__) + '/../spec_helper'

describe StrategiesController, 'routes' do

  it "should map { :controller => 'strategies', :action => 'index' } to /strategies" do
    route_for(:controller => 'strategies', :action => 'index').should == '/strategies'
  end
  
  it "should map { :controller => 'strategies', :action => 'list', :id => 1 } to /strategies/list/1" do
    route_for(:controller => 'strategies', :action => 'list', :id => 1).should == '/strategies/list/1'
  end
  
  it "should map { :controller => 'strategies', :action => 'reorder', :id => 1 } to /strategies/reorder/1" do
    route_for(:controller => 'strategies', :action => 'reorder', :id => 1).should == '/strategies/reorder/1'
  end
  
  it "should map { :controller => 'strategies', :action => 'update_strategy_order' } to /strategies/update_strategy_order" do
    route_for(:controller => 'strategies', :action => 'update_strategy_order').should == '/strategies/update_strategy_order'
  end

  it "should map { :controller => 'strategies', :action => 'show', :id => 1 } to /strategies/show/1" do
    route_for(:controller => 'strategies', :action => 'show', :id => 1).should == '/strategies/show/1'
  end

  it "should map { :controller => 'strategies', :action => 'new', :id => 1 } to /strategies/new/1" do
    route_for(:controller => 'strategies', :action => 'new', :id => 1).should == '/strategies/new/1'
  end
        
  it "should map { :controller => 'strategies', :action => 'create' } to /strategies/create" do
    route_for(:controller => 'strategies', :action => 'create').should == '/strategies/create'
  end
  
  it "should map { :controller => 'strategies', :action => 'edit', :id => 1 } to /strategies/edit/1" do
    route_for(:controller => 'strategies', :action => 'edit', :id => 1).should == '/strategies/edit/1'
  end
  
  it "should map { :controller => 'strategies', :action => 'update', :id => 1 } to /strategies/update/1" do
    route_for(:controller => 'strategies', :action => 'update', :id => 1).should == '/strategies/update/1'
  end  
  
  it "should map { :controller => 'strategies', :action => 'destroy', :id => 1 } to /strategies/destroy/1" do
    route_for(:controller => 'strategies', :action => 'destroy', :id => 1).should == '/strategies/destroy/1'
  end
  
end

describe StrategiesController, "should not allow GET requests to dangerous actions" do

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

  it "#update_strategy_order should not be successful" do
    get :update_strategy_order
    response.should_not be_success
  end
  
  it "#destroy should not be successful" do
    get :destroy
    response.should_not be_success
  end
      
end

describe StrategiesController, "should not allow access to secured actions when not logged in" do
    
  it "#index should not be successful" do
    get :index
    response.should be_redirect
  end
  
  it "#list should not be successful" do
    get :list
    response.should be_redirect
  end
  
  it "#reorder should not be successful" do
    get :reorder
    response.should be_redirect
  end
  
  it "#update_strategy_order should not be successful" do
    xhr(:post, :update_strategy_order)
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

describe StrategiesController, 'handling GET /strategies' do
  
  it "should be successful"

end

describe StrategiesController, 'handling GET /strategies/list/:id' do
  
  it "should be successful"

end

describe StrategiesController, 'handling GET /strategies/reorder/:id' do
  
  it "should be successful"

end

describe StrategiesController, 'handling XHR POST /strategies/update_strategy_order' do
  
  it "should be successful"

end

describe StrategiesController, 'handling GET /strategies/show/:id' do
  
  it "should be successful"

end

describe StrategiesController, 'handling GET /strategies/new/:id' do
  
  it "should be successful"

end

describe StrategiesController, 'handling POST /strategies/create' do
  
  it "should be successful"

end

describe StrategiesController, 'handling GET /strategies/edit/:id' do
  
  it "should be successful"

end

describe StrategiesController, 'handling POST /strategies/update/:id' do
  
  it "should be successful"

end

describe StrategiesController, 'handling POST /strategies/destroy/:id' do
  
  it "should be successful"

end