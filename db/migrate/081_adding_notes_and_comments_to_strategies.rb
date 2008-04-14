class AddingNotesAndCommentsToStrategies < ActiveRecord::Migration
  def self.up
    add_column :notes, :activity_strategy_id, :integer
    add_column :comments, :activity_strategy_id, :integer
  end

  def self.down
    remove_column :notes, :activity_strategy_id, :integer
    remove_column :comments, :activity_strategy_id, :integer
  end
end
