class AddingIndexToQuestions < ActiveRecord::Migration
  def self.up
    add_index :questions, [:activity_id, :name], :name => 'activity_and_question_name', :unique => true
    add_index :dependencies, :question_id
  end

  def self.down
    remove_index :questions, :name => :activity_and_question_name
  end
end
