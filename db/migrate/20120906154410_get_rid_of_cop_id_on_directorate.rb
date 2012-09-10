class GetRidOfCopIdOnDirectorate < ActiveRecord::Migration
  def self.up
  	remove_column :directorates, :cop_id
  end

  def self.down
  	add_column :directorates, :cop_id, :integer
  end
end
