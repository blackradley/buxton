require File.dirname(__FILE__) + '/../spec_helper'

describe SectionsController, "#route_for" do

  it "should map { :controller => 'sections', :action => 'list', :id => 'purpose' } to /sections/list/purpose" do
    route_for(:controller => 'sections', :action => 'list', :id => 'purpose').should == '/sections/list/purpose'
  end

  it "should map { :controller => 'sections', :action => 'list', :id => 'performance' } to /sections/list/performance" do
    route_for(:controller => 'sections', :action => 'list', :id => 'performance').should == '/sections/list/performance'
  end
  
  it "should map { :controller => 'sections', :action => 'list', :id => 'confidence_information' } to /sections/list/confidence_information" do
    route_for(:controller => 'sections', :action => 'list', :id => 'confidence_information').should == '/sections/list/confidence_information'
  end  

  it "should map { :controller => 'sections', :action => 'list', :id => 'confidence_consultation' } to /sections/list/confidence_consultation" do
    route_for(:controller => 'sections', :action => 'list', :id => 'confidence_consultation').should == '/sections/list/confidence_consultation'
  end

  it "should map { :controller => 'sections', :action => 'list', :id => 'additional_work' } to /sections/list/additional_work" do
    route_for(:controller => 'sections', :action => 'list', :id => 'additional_work').should == '/sections/list/additional_work'
  end
  
  it "should map { :controller => 'sections', :action => 'list', :id => 'action_planning' } to /sections/list/action_planning" do
    route_for(:controller => 'sections', :action => 'list', :id => 'action_planning').should == '/sections/list/action_planning'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'purpose' } to /sections/show/purpose" do
    route_for(:controller => 'sections', :action => 'show', :id => 'purpose').should == '/sections/show/purpose'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'performance' } to /sections/show/performance" do
    route_for(:controller => 'sections', :action => 'show', :id => 'performance').should == '/sections/show/performance'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_information' } to /sections/show/confidence_information" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_information').should == '/sections/show/confidence_information'
  end  

  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_consultation' } to /sections/show/confidence_consultation" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_consultation').should == '/sections/show/confidence_consultation'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'additional_work' } to /sections/show/additional_work" do
    route_for(:controller => 'sections', :action => 'show', :id => 'additional_work').should == '/sections/show/additional_work'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'action_planning' } to /sections/show/action_planning" do
    route_for(:controller => 'sections', :action => 'show', :id => 'action_planning').should == '/sections/show/action_planning'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'purpose', :f => 1 } to /sections/show/purpose?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'purpose', :f => 1).should == '/sections/show/purpose?f=1'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'performance', :f => 1 } to /sections/show/performance?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'performance', :f => 1).should == '/sections/show/performance?f=1'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_information', :f => 1 } to /sections/show/confidence_information?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_information', :f => 1).should == '/sections/show/confidence_information?f=1'
  end  

  it "should map { :controller => 'sections', :action => 'show', :id => 'confidence_consultation', :f => 1 } to /sections/show/confidence_consultation?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'confidence_consultation', :f => 1).should == '/sections/show/confidence_consultation?f=1'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'additional_work', :f => 1 } to /sections/show/additional_work?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'additional_work', :f => 1).should == '/sections/show/additional_work?f=1'
  end
  
  it "should map { :controller => 'sections', :action => 'show', :id => 'action_planning', :f => 1 } to /sections/show/action_planning?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'action_planning', :f => 1).should == '/sections/show/action_planning?f=1'
  end

  it "should map the various edit variances"

  it "should map { :controller => 'sections', :action => 'update' } to /sections/update" do
    route_for(:controller => 'sections', :action => 'update').should == '/sections/update'
  end

end

describe SectionsController, "should not allow GET requests to dangerous actions" do
    
end

describe SectionsController, "should not allow access to secured actions when not logged in" do
  
end