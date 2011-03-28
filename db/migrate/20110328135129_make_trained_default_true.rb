class MakeTrainedDefaultTrue < ActiveRecord::Migration
  def self.up
    remove_column :users, :trained
    add_column :users, :trained, :boolean, :default => true
  end

  def self.down
  end
end
