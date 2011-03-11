class AddingCreatorColumnToUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :roles
    add_column :users, :creator, :boolean, :default => false
  end

  def self.down
    add_column :users, :roles, :string
    remove_column :users, :creator
  end
end
