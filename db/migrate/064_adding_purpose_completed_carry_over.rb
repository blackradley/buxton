class AddingPurposeCompletedCarryOver < ActiveRecord::Migration
  def self.up
    add_column :activities, :use_purpose_completed, :boolean, :default => true
  end

  def self.down
    remove_column :activities, :use_purpose_completed
  end
end
