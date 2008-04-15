class ChangeApprovedToBool < ActiveRecord::Migration
  def self.up
    change_column :activities, :approved, :boolean, :default => false
  end

  def self.down
    change_column :activities, :approved, :integer, :default => 0    
  end
end