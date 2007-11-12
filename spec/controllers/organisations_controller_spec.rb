require File.dirname(__FILE__) + '/../spec_helper'

describe OrganisationsController, "#route_for" do

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
    
end

describe OrganisationsController, "should not allow access to secured actions when not logged in" do
  
end