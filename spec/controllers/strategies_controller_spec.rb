require File.dirname(__FILE__) + '/../spec_helper'

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

  before(:each) do
    login_as :administrator
  end
  
  it "should be successful"
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    get :index, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe StrategiesController, 'handling GET /strategies/reorder/:id' do

  before(:each) do
    login_as :administrator
  end
  
  it "should be successful"
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    get :reorder, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe StrategiesController, 'handling XHR POST /strategies/update_strategy_order' do
  
  it "should be successful"

end

describe StrategiesController, 'handling GET /strategies/show/:id' do
  
  before(:each) do
    login_as :administrator
  end
  
  it "should be successful"
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Strategy.stub!(:find).and_raise(@exception)
    get :show, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe StrategiesController, 'handling GET /strategies/new/:id' do

  before(:each) do
    login_as :administrator
  end
  
  it "should be successful"
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Organisation.stub!(:find).and_raise(@exception)
    get :new, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end  

end

describe StrategiesController, 'handling POST /organisations/:organisatrion_id/strategies' do
  
  before(:each) do
    # Prep data
    @organisation = mock_model(Organisation, :null_object => true)
    @strategy = mock_model(Strategy, {  :null_object => true,
                                        :new_record? => true,
                                        :organisation => @organisation
                                        })
    Organisation.stub!(:find).and_return(@organisation)                                        
    @organisation.strategies.stub!(:build).and_return(@strategy)

    # Authenticate
    login_as :administrator
  end

  it "should redirect to 'organisations/:organisation_id/strategies/:id' with a valid strategy" do
    @strategy.stub!(:save!).and_return(nil)
    post :create, :organisation_id => @organisation
    response.should redirect_to(organisation_strategies_url(@organisation))
  end

  it "should assign a flash message with a valid strategy"
  
  it "should render 'strategies/new' with an invalid strategy" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@strategy)
    @strategy.stub!(:save!).and_raise(@exception)
    post :create, :organisation_id => @organisation
    response.should render_template(:new)
  end
  
  it "should assign a flash message with an invalid strategy"

end

describe StrategiesController, 'handling GET /organisations/:organisation_id/strategies/:id/edit' do

  before(:each) do
    @organisation = mock_model(Organisation, :null_object => true)
    Organisation.stub!(:find).and_return(@organisation)
    login_as :administrator
  end  

  it "should be successful"
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    @organisation.strategies.stub!(:find).and_raise(@exception)
    get :edit, :organisation_id => @organisation, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe StrategiesController, 'handling PUT /organisations/:organisation_id/strategies/:id' do

  before(:each) do
    # Prep data
    @strategy = mock_model(Strategy, :null_object => true)
    @organisation = mock_model(Organisation, :null_object => true)
    Organisation.stub!(:find).and_return(@organisation)
    @organisation.strategies.stub!(:find).and_return(@strategy)

    # Authenticate
    login_as :administrator
  end

  it "should redirect to '/organisations/:organisation_id/strategies/:id' with a valid strategy" do
    @strategy.stub!(:update_attributes!).and_return(nil)
    put :update, :organisation_id => @organisation, :id => @strategy
    response.should redirect_to(organisation_strategy_url(@organisation, @strategy))
  end

  it "should assign a flash message with a valid strategy"

  it "should re-render 'strategy/edit/:id' with an invalid strategy" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@strategy)
    @strategy.stub!(:update_attributes!).and_raise(@exception)
    put :update, :organisation_id => @organisation, :id => @strategy
    response.should render_template(:edit)
  end

  it "should assign a flash message with an invalid strategy"

  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    @organisation.strategies.stub!(:find).and_raise(@exception)
    put :update, :organisation_id => @organisation, :id => @strategy
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end

describe StrategiesController, 'handling DELETE /organisations/:organisation_id/strategies/:id' do
  
  before(:each) do
    @strategy = mock_model(Strategy)    
    @strategy.stub!(:destroy).and_return(true)
    
    @organisation = mock_model(Organisation, :null_object => true)
    Organisation.stub!(:find).and_return(@organisation)
    @organisation.strategies.stub!(:find).and_return(@strategy)

    login_as :administrator
  end
  
  it "should be successful" do
    delete :destroy, :organisation_id => @organisation, :id => @strategy
    response.should be_redirect
  end
  
  it "should destroy the strategy" do
    @strategy.should_receive(:destroy)
    delete :destroy, :organisation_id => @organisation, :id => @strategy
  end
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    @organisation.strategies.stub!(:find).and_raise(@exception)
    delete :destroy, :organisation_id => @organisation, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end

end