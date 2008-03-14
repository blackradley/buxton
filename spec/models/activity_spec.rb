require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  context "it always" do
    before(:each) do
      @organisation = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation)
      @directorate = mock_model(Directorate)
      Directorate.stub!(:find).and_return(@directorate)
      @directorate.stub!(:organisation).and_return(@organisation)
      @directorate.stub!(:valid?).and_return(true)
      @activity_manager = mock_model(ActivityManager)
      ActivityManager.stub!(:find).and_return(@activity_manager)
      @activity_manager.stub!(:valid?).and_return(true)
      @activity_manager.stub!(:class).and_return(ActivityManager)
      @organisation.stub!(:valid?).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
    end
  
    it "should be only be valid with correct dependencies" do
      @activity.should_not be_valid
      @activity.activity_manager = @activity_manager
      @activity.should_not be_valid
      @activity.organisation = @organisation   
      @activity.should_not be_valid
      @activity.directorate = @directorate
      @activity.should be_valid
    end
  end
  
  context "when not started" do
    setup do
      @organisation = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation)
      @directorate = mock_model(Directorate)
      Directorate.stub!(:find).and_return(@directorate)
      @directorate.stub!(:organisation).and_return(@organisation)
      @directorate.stub!(:valid?).and_return(true)
      @activity_manager = mock_model(ActivityManager)
      ActivityManager.stub!(:find).and_return(@activity_manager)
      @activity_manager.stub!(:valid?).and_return(true)
      @activity_manager.stub!(:class).and_return(ActivityManager)
      @organisation.stub!(:valid?).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
      @activity.activity_manager = @activity_manager
      @activity.organisation = @organisation
      @strands = [:age, :gender, :race, :disability, :sexual_orientation, :faith]
      @sections = [:purpose, :impact, :consulation, :additional_work, :action_planning]     
    end
    
    it "should not show as started" do
      @activity.started.should be_false
    end
    
    it "should not have any questions started" do
      @sections.each do |section|
        @strands.each do |strand|
          @activity.started(section, strand).should be_false
        end
      end
    end
    
    it "should not be completed" do
      @activity.completed.should be_false  
    end
    
    it "should not have any strands completed" do
      @sections.each do |section|
        @strands.each do |strand|
          @activity.completed(section, strand).should be_false
        end
      end
    end
    
    it "should be 0% complete" do
      @activity.percentage_answered.should be_equal(0)
    end
    
    it "should not be existing or proposed" do
      @activity.existing_proposed?.should eql("Not Answered Yet")
    end
    
    it "should not be a function or a policy" do
      @activity.function_policy?.should eql("Not Answered Yet")
    end
  end
  
  context "When it is completed with every question needed" do
    setup do
      @organisation = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation)
      @directorate = mock_model(Directorate)
      Directorate.stub!(:find).and_return(@directorate)
      @directorate.stub!(:organisation).and_return(@organisation)
      @directorate.stub!(:valid?).and_return(true)
      @activity_manager = mock_model(ActivityManager)
      ActivityManager.stub!(:find).and_return(@activity_manager)
      @activity_manager.stub!(:valid?).and_return(true)
      @activity_manager.stub!(:class).and_return(ActivityManager)
      @organisation.stub!(:valid?).and_return(true)
      @question = mock_model(Question)
      Question.stub!(:find).and_return(@question)
      @question.stub!(:valid).and_return(true)
      @question.stub!(:completed).and_return(true)
      @question.stub!(:needed).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
      @activity.activity_manager = @activity_manager
      @activity.organisation = @organisation
      @strands = [:age, :gender, :race, :disability, :sexual_orientation, :faith]
      @sections = [:purpose, :impact, :consulation, :additional_work, :action_planning]     
    end  
  
    it "should be completed" do
      @activity.completed.should be_true
    end
    
    it "should be started" do
      @activity.started.should be_true
    end
    
    it "should be 100% complete" do
      @activity.percentage_answered.should eql(100)
    end
    
    
  end
  
 
end
