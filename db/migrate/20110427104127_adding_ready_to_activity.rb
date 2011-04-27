class AddingReadyToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :ready, :boolean
  end

  def self.down
    remove_column :activities, :ready, :boolean
  end
end
