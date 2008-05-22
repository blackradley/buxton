#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
require File.dirname(__FILE__) + '/../spec_helper'

describe SectionsController, 'routes' do

  it "should map { :controller => 'sections', :action => 'list', :id => 'purpose' } to /sections/list/purpose" do
    route_for(:controller => 'sections', :action => 'list', :id => 'purpose').should == '/sections/list/purpose'
  end

  it "should map { :controller => 'sections', :action => 'list', :id => 'impact' } to /sections/list/impact" do
    route_for(:controller => 'sections', :action => 'list', :id => 'impact').should == '/sections/list/impact'
  end

  it "should map { :controller => 'sections', :action => 'list', :id => 'consultation' } to /sections/list/consultation" do
    route_for(:controller => 'sections', :action => 'list', :id => 'consultation').should == '/sections/list/consultation'
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

  it "should map { :controller => 'sections', :action => 'show', :id => 'impact' } to /sections/show/impact" do
    route_for(:controller => 'sections', :action => 'show', :id => 'impact').should == '/sections/show/impact'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'consultation' } to /sections/show/consultation" do
    route_for(:controller => 'sections', :action => 'show', :id => 'consultation').should == '/sections/show/consultation'
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

  it "should map { :controller => 'sections', :action => 'show', :id => 'impact', :f => 1 } to /sections/show/impact?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'impact', :f => 1).should == '/sections/show/impact?f=1'
  end

  it "should map { :controller => 'sections', :action => 'show', :id => 'consultation', :f => 1 } to /sections/show/consultation?f=1" do
    route_for(:controller => 'sections', :action => 'show', :id => 'consultation', :f => 1).should == '/sections/show/consultation?f=1'
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

  it "#update should not be successful" do
    login_as :activity_manager
    get :update
    response.should_not be_success
  end
    
end

describe SectionsController, "should not allow access to secured actions when not logged in" do

  it "#list should not be successful" do
    get :list
    response.should be_redirect
  end
  
  it "#show should not be successful" do
    get :show
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
        
end

describe SectionsController, 'handling GET /sections/list/:id' do
  
  before(:each) do
    login_as :organisation_manager
  end

  it "should be successful with 'purpose'" do
    get :list, :id => 'purpose'
    response.should be_success
  end
  
  it "should be successful with 'impact'" do
    get :list, :id => 'impact'
    response.should be_success
  end
  
  it "should be successful with 'consultation'" do
    get :list, :id => 'consultation'
    response.should be_success
  end
  
  it "should be successful with 'additional_work'" do
    get :list, :id => 'additional_work'
    response.should be_success
  end
  
  it "should be successful with 'action_planning'" do
    get :list, :id => 'action_planning'
    response.should be_success
  end

  it "should be unsuccessful with an invalid section" do
    get :list, :id => 'asdasdaadas'
    response.should_not be_success
  end
  
end

describe SectionsController, 'handling GET /sections/show/:id' do
  
  before(:each) do
    login_as :activity_manager
    @activity = @current_user.activity
    @activity.stub!(:started).and_return(true)
    @activity.stub!(:function_strategies).and_return([])    
  end

  it "should be successful with 'purpose'" do
    get :show, :id => 'purpose'
    response.should be_success
  end
  
  it "should be successful with 'impact'" do
    get :show, :id => 'impact'
    response.should be_success
  end
  
  it "should be successful with 'consultation'" do
    get :show, :id => 'consultation'
    response.should be_success
  end
  
  it "should be successful with 'additional_work'" do
    get :show, :id => 'additional_work'
    response.should be_success
  end
  
  it "should be successful with 'action_planning'" do
    get :show, :id => 'action_planning'
    response.should be_success
  end
  
  it "should be unsuccessful with an invalid section"

end

describe SectionsController, 'handling GET /sections/edit/:id/:equality_strand' do
  
  it "should be successful"

end

describe SectionsController, 'handling POST /sections/update' do
  
  before(:each) do
    # Authenticate
    login_as :activity_manager
    set_referrer('/') # this isn't a legitimate source but I don't
                      # know the syntax needed here and it's not checked
                      # against. It just needs something.
    @activity = @current_user.activity
  end

  it "should redirect with a valid activity" do
    @activity.stub!(:update_attributes!).and_return(nil)
    post :update
    response.should be_redirect
  end

  it "should assign a flash message with a valid activity"
  
  it "should re-render the section show page with an invalid activity" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@activity)
    @activity.stub!(:update_attributes!).and_raise(@exception)
    post :update, { :id => 'impact', :equality_strand => 'gender' }
    response.should render_template(:edit_impact)
  end
  
  it "should assign a flash message with an invalid activity"

end