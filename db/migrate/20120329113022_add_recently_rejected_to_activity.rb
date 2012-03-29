class AddRecentlyRejectedToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :recently_rejected, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :recently_rejected
  end
end
