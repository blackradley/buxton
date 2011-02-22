require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < Test::Unit::TestCase
  subject{ Factory(:activity)}
  
  should validate_presence_of(:name).with_message(/All activities must have a name/)
  # should validate_presence_of(:activity_manager)
  # should validate_presence_of(:activity_approver)
  should validate_presence_of(:directorate)

  context "with a reference number" do
    setup do 
      @activity = Factory(:activity, :ref_no => "Banana")
    end
    
    should validate_uniqueness_of(:ref_no).with_message('Reference number must be unique')
  end
  
  existing_proposed_set = [[1,1], [1,2], [2,1], [2,2]]
  existing_proposed_set.each do |ep, fp|
    context "with an #{ep == 1 ? 'existing' : 'proposed'} #{fp == 1 ? 'function' : 'policy'}" do
      setup do 
        @activity = Factory(:activity, :existing_proposed => ep, :function_policy => fp)
      end
    
      should "#{ep == 1 ? '' : 'not'} be existing" do
        assert ep == 1 ? @activity.existing? : !@activity.existing?
      end
    
      should "#{ep == 1 ? 'not' : ''} be proposed" do
        assert ep == 2 ? @activity.proposed? : !@activity.proposed?
      end
    
      should "#{fp == 1 ? '' : 'not'} be a function" do
        assert fp == 1 ? @activity.function? : !@activity.function?
      end
    
      should "#{fp == 1 ? 'not' : ''} be a policy" do
        assert fp == 2 ? @activity.policy? : !@activity.policy?
      end
    
      should "be called a #{fp == 1 ? 'function' : 'policy'}" do
        assert_equal @activity.function_policy?, (fp == 1 ? 'function' : 'policy').titlecase
      end
      
      should "be called a #{ep == 1 ? 'existing' : 'proposed'}" do
        assert_equal @activity.existing_proposed_name, (ep == 1 ? 'existing' : 'proposed').titlecase
      end
    end 
    
    context "when toggling existing proposed on a #{ep == 1 ? 'existing' : 'proposed'} #{fp == 1 ? 'function' : 'policy'}" do
      setup do 
        old_ep = (ep == 1 ? 2 : 1)
        @activity = Factory.create(:activity, :existing_proposed => old_ep, :function_policy => fp)
        @activity.update_attributes(:existing_proposed => ep)
      end
      
      @@invisible_questions.each do |q|
        should "possible display invisible question called #{q.to_s}" do
          question_obj = @activity.questions.find_by_name(q.to_s)
          required_value = if !@activity.parents(q.to_s).blank?
            question_obj.check_needed && !@activity.proposed?
          else
            !@activity.proposed?
          end
          assert_equal question_obj.needed?, required_value,  "#{q.to_s} should have a needed value of #{required_value}"
        end
      end
    end
  end
end
