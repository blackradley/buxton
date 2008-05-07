class AddingDirectorateManager < ActiveRecord::Migration
  def self.up
    add_column :users, :directorate_id, :integer
  end

  def self.down
    remove_column :users, :directorate_id, :integer
  end
end

