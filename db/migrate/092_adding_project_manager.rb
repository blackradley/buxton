class AddingProjectManager < ActiveRecord::Migration
  def self.up
    add_column :users, :project_id, :integer
    add_column :strategies, :project_id, :integer
  end

  def self.down
    remove_column :users, :project_id
    remove_column :strategies, :project_id
  end
end
