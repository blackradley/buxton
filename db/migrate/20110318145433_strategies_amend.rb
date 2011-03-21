class StrategiesAmend < ActiveRecord::Migration
  def self.up
    remove_index :strategies, :organisation_id    
    remove_index :strategies, :directorate_id
    remove_index :strategies, :project_id
    
    remove_column :strategies, :organisation_id    
    remove_column :strategies, :directorate_id
    remove_column :strategies, :project_id
    remove_column :strategies, :type
    remove_column :strategies, :position
    
    add_column :strategies, :retired, :boolean, :default => false
  end

  def self.down
    remove_column :strategies, :retired
    
    add_column :strategies, :organisation_id, :integer
    add_column :strategies, :directorate_id, :integer
    add_column :strategies, :project_id, :integer
    add_column :strategies, :type, :string
    add_column :strategies, :position, :integer
    
    add_index :strategies, :organisation_id
    add_index :strategies, :directorate_id
    add_index :strategies, :project_id
    
  end
end
