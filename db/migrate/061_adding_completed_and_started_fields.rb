class AddingCompletedAndStartedFields < ActiveRecord::Migration
  def self.up
    add_column :activities, :overall_completed_issues, :boolean, :default => false
    add_column :activities, :overall_completed_strategies, :boolean, :default => false
    add_column :activities, :overall_completed_questions, :boolean, :default => false
    add_column :activities, :overall_started, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :overall_completed_issues
    remove_column :activities, :overall_completed_strategies
    remove_column :activities, :overall_completed_questions
    remove_column :activities, :overall_started
  end
end
