require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController, "#route_for" do

  it "should map { :controller => 'users', :action => 'index' } to /users" do
    route_for(:controller => 'users', :action => 'index').should == '/users'
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

end

describe UsersController, "should not allow GET requests to dangerous actions" do
    
end

describe UsersController, "should not allow access to secured actions when not logged in" do
  
end

describe UsersController, "handling GET /users/" do

  it "should be successful" do
    get :index
    response.should be_success
  end

end