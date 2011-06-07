# #
# # $URL$
# # $Rev$
# # $Author$
# # $Date$
# #
# # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
# #
require 'test_helper'


class CommentControllerTest < ActionController::TestCase
  
  context "A completer" do
    setup do
      sign_in users(:users_003)
    end
    
    should "not be able to create new comments on a submitted activity" do
      Activity.find(activities(:activities_002).id).update_attributes(:submitted => true)
      xhr :post, :set_comment, :comment => "this is a test comment", :question_id => 300, :activity_id => 2
      assert !Activity.find(activities(:activities_002).id).questions.find(300).comment
    end
    
    should "be able to create new comments on a question that go on the report" do
      assert_equal nil, Activity.find(activities(:activities_002).id).questions.find(300).comment
      xhr :post, :set_comment, :comment => "this is a test comment", :question_id => 300, :activity_id => 2
      assert Activity.find(activities(:activities_002).id).questions.find(300).comment
      assert_equal "this is a test comment", Activity.find(activities(:activities_002).id).questions.find(300).comment.contents
    end
    
    context "with a comment on a question" do
      setup do
        Comment.create(:question_id => 300, :contents => "this is an old test comment")
      end
        
      should "be able to edit comments on a question that go on the report" do
        assert_equal "this is an old test comment", Activity.find(activities(:activities_002).id).questions.find(300).comment.contents
        xhr :post, :set_comment, :comment => "this is a new test comment", :question_id => 300, :activity_id => 2
        assert_equal "this is a new test comment", Activity.find(activities(:activities_002).id).questions.find(300).comment.contents
      end
      
      should "be able to blank out comments and have them be deleted" do
        assert_equal "this is an old test comment", Activity.find(activities(:activities_002).id).questions.find(300).comment.contents
        xhr :post, :set_comment, :comment => "", :question_id => 300, :activity_id => 2
        assert !Activity.find(activities(:activities_002).id).questions.find(300).comment
      end
      
      should "be able to delete comments with the delete button" do
        assert_equal "this is an old test comment", Activity.find(activities(:activities_002).id).questions.find(300).comment.contents
        xhr :delete, :destroy, :question_id => 300, :activity_id => 2, :id => 2
        assert !Activity.find(activities(:activities_002).id).questions.find(300).comment
      end
      
    end
    
    should "be able to create new comments on a strategy that goes on the report" do
      assert_equal nil, Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment
      xhr :post, :edit_strategy, :comment => "this is a test comment", :activity_strategy_id => 1, :activity_id => 2
      assert Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment
      assert_equal "this is a test comment", Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment.contents
    end
    
    context "with a comment on a strategy" do
      setup do
        Comment.create(:activity_strategy_id => 1, :contents => "this is an old test comment")
      end
      
      should "be able to edit comments on a strategy that go on the report" do
        assert_equal "this is an old test comment",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment.contents
        xhr :post, :edit_strategy, :comment => "this is a new test comment", :activity_strategy_id => 1, :activity_id => 2
        assert_equal "this is a new test comment",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment.contents
      end
      
      should "be able to blank out comments and have them deleted" do
        assert_equal "this is an old test comment",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment.contents
        xhr :post, :edit_strategy, :comment => "", :activity_strategy_id => 1, :activity_id => 2
        assert !Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment
      end
      
      should "be able to delete comments with the delete button" do
        assert_equal "this is an old test comment",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment.contents
        xhr :delete, :destroy_strategy, :activity_strategy_id => 1, :activity_id => 2, :id => 2
        assert !Activity.find(activities(:activities_002).id).activity_strategies.find(1).comment
      end
      
    end
    
  end
  
end