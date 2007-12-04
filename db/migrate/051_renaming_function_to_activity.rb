class RenamingFunctionToActivity < ActiveRecord::Migration
  def self.up
    rename_column :function_strategies, :function_id, :activity_id
    rename_table :functions, :activities
    rename_table :function_strategies, :activity_strategies
    rename_column :issues, :function_id, :activity_id
  end

  def self.down
    rename_table :activities, :functions
    rename_table :activity_strategies, :function_strategies
    rename_column :issues, :activity_id, :function_id
    rename_column :function_strategies, :activity_id, :function_id
  end
end
