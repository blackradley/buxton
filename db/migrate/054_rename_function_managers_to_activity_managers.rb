class RenameFunctionManagersToActivityManagers < ActiveRecord::Migration
  def self.up
    rename_column :activities, :function_manager_id, :activity_manager_id
  end

  def self.down
    rename_column :activities, :activity_manager_id, :function_manager_id
  end
end
