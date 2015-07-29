# #
# # $URL$
# # $Rev$
# # $Author$
# # $Date$
# #
# # Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
# #
require 'test_helper'


class NoteControllerTest < ActionController::TestCase
  
  context "A completer" do
    setup do
      sign_in users(:users_003)
    end
    
    should "not be able to create new notes on a submitted activity" do
      Activity.find(activities(:activities_002).id).update_attributes(:submitted => true)
      xhr :post, :set_note, :note => "this is a test note", :question_id => 300, :activity_id => 2
      assert !Activity.find(activities(:activities_002).id).questions.find(300).note
    end
    
    should "be able to create new notes on a question that go on the report" do
      assert_equal nil, Activity.find(activities(:activities_002).id).questions.find(300).note
      xhr :post, :set_note, :note => "this is a test note", :question_id => 300, :activity_id => 2
      assert Activity.find(activities(:activities_002).id).questions.find(300).note
      assert_equal "this is a test note", Activity.find(activities(:activities_002).id).questions.find(300).note.contents
    end
    
    context "with a note on a question" do
      setup do
        Note.create(:question_id => 300, :contents => "this is an old test note")
      end
        
      should "be able to edit notes on a question that go on the report" do
        assert_equal "this is an old test note", Activity.find(activities(:activities_002).id).questions.find(300).note.contents
        xhr :post, :set_note, :note => "this is a new test note", :question_id => 300, :activity_id => 2
        assert_equal "this is a new test note", Activity.find(activities(:activities_002).id).questions.find(300).note.contents
      end
      
      should "be able to blank out notes and have them be deleted" do
        assert_equal "this is an old test note", Activity.find(activities(:activities_002).id).questions.find(300).note.contents
        xhr :post, :set_note, :note => "", :question_id => 300, :activity_id => 2
        assert !Activity.find(activities(:activities_002).id).questions.find(300).note
      end
      
      should "be able to delete notes with the delete button" do
        assert_equal "this is an old test note", Activity.find(activities(:activities_002).id).questions.find(300).note.contents
        xhr :delete, :destroy, :question_id => 300, :activity_id => 2, :id => 2
        assert !Activity.find(activities(:activities_002).id).questions.find(300).note
      end
      
    end
    
    should "be able to create new notes on a strategy that goes on the report" do
      assert_equal nil, Activity.find(activities(:activities_002).id).activity_strategies.find(1).note
      xhr :post, :edit_strategy, :note => "this is a test note", :activity_strategy_id => 1, :activity_id => 2
      assert Activity.find(activities(:activities_002).id).activity_strategies.find(1).note
      assert_equal "this is a test note", Activity.find(activities(:activities_002).id).activity_strategies.find(1).note.contents
    end
    
    context "with a note on a strategy" do
      setup do
        Note.create(:activity_strategy_id => 1, :contents => "this is an old test note")
      end
      
      should "be able to edit notes on a strategy that go on the report" do
        assert_equal "this is an old test note",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).note.contents
        xhr :post, :edit_strategy, :note => "this is a new test note", :activity_strategy_id => 1, :activity_id => 2
        assert_equal "this is a new test note",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).note.contents
      end
      
      should "be able to blank out notes and have them deleted" do
        assert_equal "this is an old test note",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).note.contents
        xhr :post, :edit_strategy, :note => "", :activity_strategy_id => 1, :activity_id => 2
        assert !Activity.find(activities(:activities_002).id).activity_strategies.find(1).note
      end
      
      should "be able to delete notes with the delete button" do
        assert_equal "this is an old test note",  Activity.find(activities(:activities_002).id).activity_strategies.find(1).note.contents
        xhr :delete, :destroy_strategy, :activity_strategy_id => 1, :activity_id => 2, :id => 2
        assert !Activity.find(activities(:activities_002).id).activity_strategies.find(1).note
      end
      
    end
    
  end
  
end