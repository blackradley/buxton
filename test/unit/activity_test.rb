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
      
      should "be started" do
        assert @activity.started
      end
      
      #should not have any strands or sections started. Method is broken!
      # Activity.strands.each do |strand|
      #   Activity.sections.each do |section|
      #     should "not have strand #{strand} and section #{section} started" do
      #       assert !@activity.started(section, strand)
      #     end
      #   end
      # end
      
      
    end 
    
    Activity.strands.each_with_index do |strand, index|
      Activity.sections.each do |section|
        next if section == :action_planning
        context "when checking for the completeness of #{strand.to_s} #{section.to_s} on a #{ep == 1 ? 'existing' : 'proposed'} #{fp == 1 ? 'function' : 'policy'}" do
          setup do
            old_ep = (ep == 1 ? 2 : 1)
            @activity_set = Factory(:activity, :existing_proposed => old_ep, :function_policy => fp)
            @activity_set.update_attributes(:existing_proposed => ep)
            @new_activity = Activity.find(@activity_set.id)
            question_names = Activity.get_question_names.map(&:to_s).select{|n| n.include?(strand.to_s) && n.include?(section.to_s)}.sort
            @mock_answers = []
            question_names.each do |q|
              @new_activity.reload
              if @new_activity.questions.find_by_name(q.to_s).check_needed
                mock_answer = get_mock_answer(q)
                if q ==  "impact_#{strand}_9" && mock_answer == 1
                 Factory.create(:issue, :activity => @new_activity, :section => section.to_s, :strand => strand)
                end
                if q == "consultation_#{strand}_7" && mock_answer == 1
                  Factory.create(:issue, :activity => @new_activity, :section => section.to_s, :strand => strand)
                end
                @mock_answers << [q, mock_answer]
                @new_activity.update_attributes!(q => mock_answer)
              end
              @new_activity.saved = false
            end
          end
          
          should "be complete when all required questions are filled in" do
            # puts question_names = Activity.get_question_names.map(&:to_s).select{|n| n.include?(strand.to_s) && n.include?(section.to_s)}.map{|q| Activity.find(@new_activity.id).questions.find_by_name(q.to_s)}.inspect
            assert @new_activity.completed(section, strand), "#{section} #{strand} should be complete with the answer set #{@mock_answers.inspect}"
          end
          
        end
      end
    end
    
    Activity.strands.each do |strand|
      context "when checking for the completeness of an entire strand #{strand.to_s} on a #{ep == 1 ? 'existing' : 'proposed'} #{fp == 1 ? 'function' : 'policy'}" do
        setup do
          old_ep = (ep == 1 ? 2 : 1)
          @activity_set = Factory(:activity, :existing_proposed => old_ep, :function_policy => fp)
          @activity_set.update_attributes(:existing_proposed => ep)
          @new_activity = Activity.find(@activity_set.id)
          @mock_answers = []
          Activity.sections.each do |section|
            next if section == :action_planning
            question_names = Activity.get_question_names.map(&:to_s).select{|n| n.include?(strand.to_s) && n.include?(section.to_s)}.sort
            question_names.each do |q|
              @new_activity.reload
              if @new_activity.questions.find_by_name(q.to_s).check_needed
                mock_answer = get_mock_answer(q)
                if q ==  "impact_#{strand}_9" && mock_answer == 1
                 Factory.create(:issue, :activity => @new_activity, :section => section.to_s, :strand => strand)
                end
                if q == "consultation_#{strand}_7" && mock_answer == 1
                  Factory.create(:issue, :activity => @new_activity, :section => section.to_s, :strand => strand)
                end
                @mock_answers << [q, mock_answer]
                @new_activity.update_attributes!(q => mock_answer)
              end
              @new_activity.saved = false
            end
          end
        end
        
        should "be complete when all required questions are filled in" do
          # puts question_names = Activity.get_question_names.map(&:to_s).select{|n| n.include?(strand.to_s) && n.include?(section.to_s)}.map{|q| Activity.find(@new_activity.id).questions.find_by_name(q.to_s)}.inspect
          assert @new_activity.completed(nil, strand), "#{strand} should be complete with the answer set #{@mock_answers.inspect}"
        end
        
        
        
      end
    end
    
    Activity.sections.each do |section|
      next if section == :action_planning
      context "when checking for the completeness of an entire section #{section.to_s} on a #{ep == 1 ? 'existing' : 'proposed'} #{fp == 1 ? 'function' : 'policy'}" do
        setup do
          old_ep = (ep == 1 ? 2 : 1)
          @activity_set = Factory(:activity, :existing_proposed => old_ep, :function_policy => fp)
          @activity_set.update_attributes(:existing_proposed => ep)
          @new_activity = Activity.find(@activity_set.id)
          @mock_answers = []
          Activity.strands.each do |strand|
            question_names = Activity.get_question_names.map(&:to_s).select{|n| n.include?(strand.to_s) && n.include?(section.to_s)}.sort
            question_names.each do |q|
              @new_activity.reload
              if @new_activity.questions.find_by_name(q.to_s).check_needed
                mock_answer = get_mock_answer(q)
                if q ==  "impact_#{strand}_9" && mock_answer == 1
                 Factory.create(:issue, :activity => @new_activity, :section => section.to_s, :strand => strand)
                end
                if q == "consultation_#{strand}_7" && mock_answer == 1
                  Factory.create(:issue, :activity => @new_activity, :section => section.to_s, :strand => strand)
                end
                @mock_answers << [q, mock_answer]
                @new_activity.update_attributes!(q => mock_answer)
              end
              @new_activity.saved = false
            end
          end
        end
        
        should "be complete when all required questions are filled in" do
          # puts question_names = Activity.get_question_names.map(&:to_s).select{|n| n.include?(strand.to_s) && n.include?(section.to_s)}.map{|q| Activity.find(@new_activity.id).questions.find_by_name(q.to_s)}.inspect
          assert @new_activity.completed(section, nil), "#{section} should be complete with the answer set #{@mock_answers.inspect}"
        end
        
      end
    end
    
    context "when toggling existing proposed on a #{ep == 1 ? 'existing' : 'proposed'} #{fp == 1 ? 'function' : 'policy'}" do
      setup do 
        old_ep = (ep == 1 ? 2 : 1)
        @activity_set = Factory.create(:activity, :existing_proposed => old_ep, :function_policy => fp)
        @activity = Activity.find(@activity_set.id)
        @activity.update_attributes(:existing_proposed => ep)
      end
      
      @@invisible_questions.each do |q|
        should "possible display invisible question called #{q.to_s}" do
          question_obj = @activity.questions.find_by_name(q.to_s)
          required_value = required_question?(@activity, q)
          assert_equal question_obj.needed?, required_value,  "#{q.to_s} should have a needed value of #{required_value}"
        end
      end
    end
  end
end
