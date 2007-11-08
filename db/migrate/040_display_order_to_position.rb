class DisplayOrderToPosition < ActiveRecord::Migration
  def self.up
  	rename_column :strategies, :display_order,	:position
  	rename_column :look_ups, :display_order,	:position
  end

  def self.down
  	rename_column :look_ups, :position,	:display_order
  	rename_column :strategies, :position,	:display_order
  end
end
