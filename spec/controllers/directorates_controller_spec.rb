require File.dirname(__FILE__) + '/../spec_helper'

describe DirectoratesController, 'routes' do

  it "should map { :controller => 'directorates', :action => 'new' } to /directorates/new" do
    route_for(:controller => 'directorates', :action => 'new').should == '/directorates/new'
  end
  
end