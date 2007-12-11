class AddingApprovedAt < ActiveRecord::Migration
  def self.up
    add_column :activities, :approved_on, :timestamp
  end

  def self.down
    remove_column :activities, :approved_on, :timestamp
  end
end
