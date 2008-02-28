class FlippingDefaultNeededFlag < ActiveRecord::Migration
  def self.up
    change_column :questions, :needed, :boolean, :default => false
  end

  def self.down
    change_column :questions, :needed, :boolean, :default => true
  end
end
