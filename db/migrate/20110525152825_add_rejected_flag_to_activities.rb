class AddRejectedFlagToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :is_rejected, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :is_rejected
  end
end
