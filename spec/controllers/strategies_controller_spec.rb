require File.dirname(__FILE__) + '/../spec_helper'

describe StrategiesController, "#route_for" do

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
    
end

describe StrategiesController, "should not allow access to secured actions when not logged in" do
    
end