class ChangedAssociationsForSti < ActiveRecord::Migration
  def self.up
    rename_column :organisations, :user_id, :organisation_manager_id
    rename_column :functions, :user_id, :function_manager_id    
  end

  def self.down
    rename_column :functions, :function_manager_id, :user_id    
    rename_column :organisations, :organisation_manager_id, :user_id  
  end
end
