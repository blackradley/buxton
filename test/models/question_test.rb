#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase

  context "for a stand alone text question" do

    setup do
      @activity = FactoryGirl.build(:activity)
      @question = FactoryGirl.create(:question, :input_type => "text", :activity => @activity)
      @question.save!

    end

    should "have no parents" do
      assert !@question.parent
    end

    should "have no children" do
      assert @question.children.blank?
      assert @question.dependency_mapping.blank?
    end

    should "have no dependencies" do
      assert @question.dependencies.blank?
    end

    should "be needed by default" do
      assert @question.needed
    end

    should "not be completed" do
      assert !@question.completed
    end

    context "when answered" do

      setup do
        @question.update_attributes(:raw_answer => "A sample response")
      end

      should "output the correct response" do
        assert_equal "A sample response", @question.response
        assert_equal "A sample response", @question.display_response
      end

      should "be completed" do
        assert @question.completed
      end

      should "still be needed" do
        assert @question.needed
      end

    end
  end


  context "for a stand alone select question" do

    setup do
      @activity = FactoryGirl.build(:activity)
      @question = FactoryGirl.create(:question, :input_type => "select", :needed => true, :activity => @activity, :choices => ["Not Answered", "Yes", "No"])
      @question.save!
    end

    should "have no dependencies" do
      assert @question.dependencies.blank?
    end

    should "have no parents" do
      assert !@question.parent
    end

    should "have no children" do
      assert @question.children.blank?
      assert @question.dependency_mapping.blank?
    end

    should "be needed by default" do
      assert @question.needed
    end

    should "not be completed" do
      assert !@question.completed
    end

    context "when answered" do

      setup do
        @question.update_attributes(:raw_answer => "1")
      end

      should "output the correct response" do
        assert_equal 1, @question.response
        assert_equal "Yes", @question.display_response
      end

      should "be completed" do
        assert @question.completed
      end

      should "still be needed" do
        assert @question.needed
      end

    end


    context "when answered with not answered" do

      setup do
        @question.update_attributes(:raw_answer => "0")
      end

      should "output the correct response" do
        assert_equal 0, @question.response
        assert_equal "Not Answered", @question.display_response
      end

      should "not be completed" do
        assert !@question.completed
      end

      should "still be needed" do
        assert @question.needed
      end

    end

  end


  context "For a select question with children" do
    setup do
      @activity = FactoryGirl.create(:activity)
      @question = FactoryGirl.create(:question, :input_type => "select", :needed => true, :activity => @activity, :choices => ["Not Answered", "Yes", "No"])
      @child_question = FactoryGirl.create(:question, :input_type => "select", :needed => false, :activity => @activity, :choices => ["Not Answered", "Yes", "No"])
      @question.dependencies.create!(:child_question => @child_question, :required_value => 1)
      @question.save!
    end

    should "not need the child question originally" do
      assert !@child_question.needed
    end

    should "still need the parent question" do
      assert @question.needed
    end

    should "list the dependency in the dependency mapping" do
      # @question.inspect
      assert_equal @question.dependency_mapping, {@child_question.name => 1}
    end

    should "mark the parent as having children" do
      assert_equal 1, @question.children.size
    end

    should "mark the child as having a parent" do
      assert @child_question.parent
    end


    context "when the parent is answered in such a way to enable the child" do

      setup do
        @question.update_attributes!(:raw_answer => 1)
        @child_question.reload
      end

      should "mark the child question as needed" do
        assert @child_question.needed
      end

      should "not mark the child question as completed" do
        assert !@child_question.completed
      end

      context "when the child is then updated with a correct answer" do

        setup do
          @child_question.update_attributes!(:raw_answer => 2)
        end

        should "still mark the child as needed" do
          assert @child_question.needed
        end

        should "mark the child as completed" do
          assert @child_question.completed
        end
      end
    end

    context "when the parent is answered in such a way as to not enable the child" do
      setup do
        @question.update_attributes(:raw_answer => 2)
      end

      should "not mark the child question as needed" do
        assert !@child_question.needed
      end

      should "not mark the child question as completed" do
        assert !@child_question.completed
      end

      context "when the child is then updated with a correct answer" do

        setup do
          @child_question.update_attributes(:raw_answer => 2)
        end

        should "still not mark the child as needed" do
          assert !@child_question.needed
        end

        should "mark the child as completed" do
          assert @child_question.completed
        end
      end
    end
  end
end
