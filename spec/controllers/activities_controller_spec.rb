require File.dirname(__FILE__) + '/../spec_helper'

describe ActivitiesController, "should not allow GET requests to dangerous actions" do

  it "#create should not be successful" do
    login_as :organisation_manager
    get :create
    response.should_not be_success
  end

  it "#update should not be successful" do
    login_as :activity_manager
    get :update
    response.should_not be_success
  end

  it "#update_contact should not be successful" do
    login_as :organisation_manager
    get :update_contact
    response.should_not be_success
  end
  
  it "#update_activity_type should not be successful" do
    login_as :activity_manager
    get :update_activity_type
    response.should_not be_success
  end
  
  it "#destroy should not be successful" do
    login_as :organisation_manager
    get :destroy
    response.should_not be_success
  end  
    
end

describe ActivitiesController, "should not allow access to secured actions when not logged in" do
  
  it "#index should not be successful" do
    get :index
    response.should be_redirect
  end
  
  it "#summary should not be successful" do
    get :summary
    response.should be_redirect
  end
  
  it "#show should not be successful" do
    get :show
    response.should be_redirect
  end
  
  it "#overview should not be successful" do
    get :overview
    response.should be_redirect
  end
  
  it "#list should not be successful" do
    get :list
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

  it "#update should not be successful" do
    post :update
    response.should be_redirect
  end
  
  it "#update_activity_type should not be successful" do
    post :update_activity_type
    response.should be_redirect
  end
  
  it "#edit_contact should not be successful" do
    get :edit_contact
    response.should be_redirect
  end
  
  it "#update_contact should not be successful" do
    post :update_contact
    response.should be_redirect
  end
  
  it "#destroy should not be successful" do
    post :destroy
    response.should be_redirect
  end
  
  it "#print should not be successful" do
    get :print
    response.should be_redirect
  end
  
end

describe ActivitiesController, 'handling GET /activities' do
  
  it "should be successful"

end

describe ActivitiesController, "handling GET /activities/summary" do

  it "should be successful" do
    login_as :organisation_manager
    get :summary
    response.should be_success
  end
  
  it "should not allow access to a activities manager"
  
  it "should not allow access to an administrator"  

end

describe ActivitiesController, "handling GET /activities/show" do

  it "should be successful" do
    login_as :activity_manager
    get :show
    response.should be_success
  end
  
end

describe ActivitiesController, "handling GET /activities/overview" do

  it "should be successful" do
    login_as :activity_manager
    get :overview
    response.should be_success
  end
  
end

describe ActivitiesController, "handling GET /activities/list" do

  it "should be successful" do
    login_as :organisation_manager
    get :list
    response.should be_success
  end
  
end

describe ActivitiesController, "handling GET /activities/new" do

  before(:each) do
    # Prep data
    @activity = mock_model(Activity, :null_object => true)
    @activity_manager = mock_model(ActivityManager, :null_object => true)
    
    Activity.stub!(:new).and_return(@activity)
    @activity.stub!(:build_activity_manager).and_return(@activity_manager)

    # Authenticate
    login_as :organisation_manager    
  end
  
  it "should provide a new Activity for the view" do
    Activity.should_receive(:new).and_return(@activity)
    get :new
  end

  it "should provide a new ActivityManager for the view" do
    @activity.should_receive(:build_activity_manager).and_return(@activity_manager)
    get :new
  end

  it "should be successful" do
    get :new
    response.should be_success
  end
  
end

describe ActivitiesController, "handling POST /activities/create" do

  before(:each) do
    # Prep data
    @activity = mock_model(Activity, {  :null_object => true,
                                        :new_record? => true
                                        })
    @activity_manager = mock_model(ActivityManager, :null_object => true)
    
    Activity.stub!(:new).and_return(@activity)
    @activity.stub!(:build_activity_manager).and_return(@activity_manager)

    # Authenticate
    login_as :organisation_manager
  end

  it "should tell the Activity model to create a new activities" do
    Activity.should_receive(:new).and_return(@activity)
    post :create
  end
  
  it "should tell the new activities to create a new user associated with itself" do
    @activity.should_receive(:build_activity_manager).and_return(@activity_manager)
    post :create
  end
  
  it "should redirect to 'activities/list' with a valid activity" do
    @activity.stub!(:save!).and_return(nil)
    post :create
    response.should be_redirect
  end
  
  it "should assign a flash message with a valid activity"
  
  it "should re-render 'activities/new' with an invalid activity" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@activity)
    @activity.stub!(:save!).and_raise(@exception)
    post :create
    response.should render_template(:new)
  end

  it "should assign a flash message with an invalid activity"
  
end

describe ActivitiesController, "handling POST /activities/update" do

  before(:each) do
    # Authenticate
    login_as :activity_manager
    @activity = @current_user.activity
    set_referrer('/') # this isn't a legitimate source but I don't
                      # know the syntax needed here and it's not checked
                      # against. It just needs something.
  end

  it "should redirect to 'activities/list' with a valid activity" do
    @activity.stub!(:update_attributes!).and_return(nil)
    post :update
    response.should be_redirect
  end

  it "should assign a flash message with a valid activity"
  
  it "should re-render 'activities/show/:id' with an invalid activity" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@activity)
    @activity.stub!(:update_attributes!).and_raise(@exception)
    post :update
    response.should render_template(:show)
  end
  
  it "should assign a flash message with an invalid activity"  
  
end

describe ActivitiesController, "handling GET /activities/activity_type" do
  
  it "should be successful" do
    login_as :activity_manager
    get :activity_type
    response.should be_success
  end
  
  it "should re-show the activity_type page if the status questions remain unanswered"

  it "should not allow access to an organisation manager"
  
  it "should not allow access to an administrator"
  
end

describe ActivitiesController, "handling POST /activities/update_activity_type" do

  before(:each) do
    # Authenticate
    login_as :activity_manager
    @activity = @current_user.activity
  end

  it "should redirect to 'activities/show' with a valid activity and all activity_type questions answered" do
    @activity.stub!(:update_attributes!).and_return(nil)
    @activity.stub!(:started).and_return(true)
    post :update_activity_type
    response.should redirect_to(:action => 'show')
  end

  it "should redirect to 'activities/activity_type' with a valid activity but not all activity_type questions answered" do
    @activity.stub!(:update_attributes!).and_return(nil)
    @activity.stub!(:started).and_return(false)
    post :update_activity_type
    response.should redirect_to(:action => 'activity_type')
  end

  it "should assign a flash message with a valid activity and all activity_type questions answered"
  
  it "should assign a flash message with a valid activity but not all activity_type questions answered"  
  
  it "should re-render 'activities/activity_type' with an invalid activity" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@activity)
    @activity.stub!(:update_attributes!).and_raise(@exception)
    post :update_activity_type
    response.should render_template(:activity_type)
  end
  
  it "should assign a flash message with an invalid activity"  
  
end

describe ActivitiesController, "handling GET /activities/edit_contact/:id" do

  before(:each) do
    login_as :organisation_manager    
  end

  it "should be successful"
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Activity.stub!(:find).and_raise(@exception)
    get :edit_contact, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end
  
end

describe ActivitiesController, "handling POST /activities/update_contact/:id" do

  before(:each) do
    @activity = mock_model(Activity, :null_object => true)
    Activity.stub!(:find).and_return(@activity)
    
    # Authenticate
    login_as :organisation_manager
  end

  it "should redirect to 'activities/list' with a valid activity" do
    @activity.stub!(:update_attributes!).and_return(nil)
    post :update_contact
    response.should redirect_to(:action => 'list')
  end

  it "should assign a flash message with a valid activity"
  
  it "should re-render 'activities/edit_contact' with an invalid activity" do
    @exception = ActiveRecord::RecordNotSaved.new
    @exception.stub!(:record).and_return(@activity)
    @activity.stub!(:update_attributes!).and_raise(@exception)
    post :update_contact
    response.should render_template(:edit_contact)
  end
  
  it "should assign a flash message with an invalid activity"  

  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Activity.stub!(:find).and_raise(@exception)
    post :update_contact, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end
  
end

describe ActivitiesController, "handling POST /activities/destroy/:id" do

  before(:each) do
    @activity = mock_model(Activity)
    Activity.stub!(:find).and_return(@activity)
    @activity.stub!(:destroy).and_return(true)
    login_as :organisation_manager
  end
  
  it "should be successful" do
    post :destroy, :id => @activity.id
    response.should be_redirect
  end
  
  it "should destroy the organisation" do
    @activity.should_receive(:destroy)
    post :destroy, :id => @activity.id
  end
  
  it "should render 404 file when given an invalid ID" do
    @exception = ActiveRecord::RecordNotFound.new
    Activity.stub!(:find).and_raise(@exception)
    post :destroy, :id => 'broken'
    response.should render_template("#{RAILS_ROOT}/public/404.html")
    response.headers["Status"].should eql("404 Not Found")
  end
  
end

describe ActivitiesController, "handling GET /activities/print" do

  it "should be successful"
  
end