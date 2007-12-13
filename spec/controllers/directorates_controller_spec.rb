require File.dirname(__FILE__) + '/../spec_helper'

describe DirectoratesController, 'routes' do

  it "should map { :controller => 'directorates', :action => 'new' } to /directorates/new" do
    route_for(:controller => 'directorates', :action => 'new').should == '/directorates/new'
  end

  it "should map { :controller => 'directorates', :action => 'create' } to /directorates/create" do
    route_for(:controller => 'directorates', :action => 'create').should == '/directorates/create'
  end
  
  it "should map { :controller => 'directorates', :action => 'destroy', :id => 1 } to /directorates/destroy/1" do
    route_for(:controller => 'directorates', :action => 'destroy', :id => 1).should == '/directorates/destroy/1'
  end  
  
end

describe DirectoratesController, "handling POST /directorates/destroy/:id" do

  before(:each) do
    login_as :administrator
  end
    
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Directorate.stub!(:find).and_raise(@exception)
    post :destroy, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end
  
end