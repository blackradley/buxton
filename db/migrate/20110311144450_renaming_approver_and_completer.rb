class RenamingApproverAndCompleter < ActiveRecord::Migration
  def self.up
    rename_column :activities, :activity_manager_id, :completer_id
    rename_column :activities, :activity_approver_id, :approver_id
  end

  def self.down
    rename_column :activities, :completer_id, :activity_manager_id
    rename_column :activities, :approver_id, :activity_approver_id    
  end
end
