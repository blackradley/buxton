require File.dirname(__FILE__) + '/../spec_helper'

describe Activity do
  context "it always" do
    before(:each) do
      @organisation_1 = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation_1)
      @function_manager = mock_model(FunctionManager)
      FunctionManager.stub!(:find).and_return(@function_manager)
      @function_manager.stub!(:valid?).and_return(true)
      @function_manager.stub!(:class).and_return(FunctionManager)
      @organisation_1.stub!(:valid?).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
    end
  
    it "should be only be valid with correct dependencies" do
      @activity.should_not be_valid
      @activity.function_manager = @function_manager
      @activity.should_not be_valid
      @activity.organisation = @organisation_1   
      @activity.should be_valid
    end
  end
  
  context "when not started" do
    setup do
      @organisation_1 = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation_1)
      @function_manager = mock_model(FunctionManager)
      FunctionManager.stub!(:find).and_return(@function_manager)
      @function_manager.stub!(:valid?).and_return(true)
      @function_manager.stub!(:class).and_return(FunctionManager)
      @organisation_1.stub!(:valid?).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
      @activity.function_manager = @function_manager
      @activity.organisation = @organisation_1
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
    
    it "should have no statistics" do
      @activity.statistics.should be_nil
    end
    
    it "should not be existing or proposed" do
      @activity.existing_proposed?.should eql("Not Answered Yet")
    end
    
    it "should not be a function or a policy" do
      @activity.function_policy?.should eql("Not Answered Yet")
    end
  end
  
  context "when completed with no strategies and is an existing function" do
    
    setup do
      @organisation_1 = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation_1)
      @function_manager = mock_model(FunctionManager)
      FunctionManager.stub!(:find).and_return(@function_manager)
      @function_manager.stub!(:valid?).and_return(true)
      @function_manager.stub!(:class).and_return(FunctionManager)
      @organisation_1.stub!(:valid?).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
      @activity.function_manager = @function_manager
      @activity.organisation = @organisation_1
      @strands = [:age, :gender, :race, :disability, :sexual_orientation, :faith]
      @sections = [:purpose, :impact, :consulation, :additional_work, :action_planning]
      Activity.get_question_names.each do |question|
        @activity.stub!(question).and_return(1)
      end
      @activity.stub!(:existing_proposed).and_return(1)
      @activity.stub!(:function_policy).and_return(1)
      @activity.statistics
    end
    
    it "should be started" do
      @activity.started.should be_true
    end
    
    it "should be completed" do
      @activity.completed.should be_true
    end
    
    it "should be 100% complete" do
      @activity.percentage_answered.should be_equal(100)
    end
    
    it "should have statistics" do
      @activity.stat_function.should_not be_nil
    end
    
    it "should have an low impact" do
      @activity.statistics
      @activity.stat_function.impact.should be_eql(:low)
    end
    
    it "should have a priority ranking of 1" do
      @activity.stat_function.priority_ranking.should be_eql(2)
    end
    
    it "should not be relevant" do
      @activity.stat_function.relevance.should be_false
    end
    
    it "should have the correct text for an existing function on gender strand" do
      response = @activity.question_wording_lookup(:purpose, :gender, 3)
      #Test label text is right
      response[0].should be_eql("Would it affect <strong>men and women</strong> differently?")
      #Test type of response is correctly read
      response[1].should be_eql('select')
      #Test the id of the options are correctly read
      response[2].should be_eql(1)
      #Test the help text is correctly read
      response[3].should be_eql("")
      #Test the weights are correctly read
      response[4].should be_eql(1)
    end
    
    it "should have the correct text when it is set to a proposed policy on faith strand" do
      @activity.stub!(:existing_proposed).and_return(2)
      @activity.stub!(:function_policy).and_return(2)      
      response = @activity.question_wording_lookup(:purpose, :faith, 3)
      #Test label text is right
      response[0].should be_eql("If the policy was performed well does it affect individuals of different faiths differently?")
      #Test type of response is correctly read
      response[1].should be_eql('select')
      #Test the id of the options are correctly read
      response[2].should be_eql(1)
      #Test the help text is correctly read
      response[3].should be_eql("")
      #Test the weights are correctly read
      response[4].should be_eql(1)
      @activity.stub!(:existing_proposed).and_return(1)
      @activity.stub!(:function_policy).and_return(1)   
    end
    
    it "should have the correct additional work prelude text" do
      
      correct_question_1_answer = "If the function were performed well it would not affect men and women differently."
      correct_question_2_answer = "If the function were performed badly it would not affect men and women differently."
      correct_question_3_answer = "The performance of the function in meeting the different needs of men and women is poor. This performance assessment has been validated."
      correct_question_4_answer = "There are performance issues that might have different implications for men and women"
      correct_question_5_answer = "There are gaps in the information to monitor the performance of the function in meeting the needs of men and women"
      correct_question_6_answer = "Groups representing men and women have been consulted and experts have been consulted. The consultations did not identify any issues with the impact of the function upon men and women."
      correct_question_7_answer = "For the gender equality strand the Activity has an overall priority ranking of 2 and a Potential Impact rating of Low."
    
      @activity.additional_work_text_lookup(:gender, 1).should be_eql(correct_question_1_answer)
      @activity.additional_work_text_lookup(:gender, 2).should be_eql(correct_question_2_answer)
      @activity.additional_work_text_lookup(:gender, 3).should be_eql(correct_question_3_answer)
      @activity.additional_work_text_lookup(:gender, 4).should be_eql(correct_question_4_answer)
      @activity.additional_work_text_lookup(:gender, 5).should be_eql(correct_question_5_answer)
      @activity.additional_work_text_lookup(:gender, 6).should be_eql(correct_question_6_answer)
      @activity.additional_work_text_lookup(:gender, 7).should be_eql(correct_question_7_answer)
    end
  end
  
  context "when it still has no strategies, but it answers no to everything instead of yes" do
    
    setup do
      @activity = nil
      @organisation_1 = mock_model(Organisation)
      Organisation.stub!(:find).and_return(@organisation_1)
      @function_manager = mock_model(FunctionManager)
      FunctionManager.stub!(:find).and_return(@function_manager)
      @function_manager.stub!(:valid?).and_return(true)
      @function_manager.stub!(:class).and_return(FunctionManager)
      @organisation_1.stub!(:valid?).and_return(true)
      @activity = Activity.new(:name => "Testing Activity")
      @activity.function_manager = @function_manager
      @activity.organisation = @organisation_1
      @strands = [:age, :gender, :race, :disability, :sexual_orientation, :faith]
      @sections = [:purpose, :impact, :consulation, :additional_work, :action_planning]
      Activity.get_question_names.each do |question|
        @activity.stub!(question).and_return(2)
      end
      @activity.stub!(:existing_proposed).and_return(1)
      @activity.stub!(:function_policy).and_return(1)
      @activity.statistics
    end 
    
    it "should have statistics" do
      @activity.stat_function.should_not be_nil
    end
    
    it "should have an medium impact" do
      @activity.stat_function.impact.should be_eql(:medium)
    end
    
    it "should have a priority ranking of 1" do
      @activity.stat_function.priority_ranking.should be_eql(2)
    end
    
    it "should be relevant" do
      @activity.stat_function.relevance.should be_true
    end    
  end
 
end
