class AddingCreatorToDirectorate < ActiveRecord::Migration
  def self.up
    add_column :directorates, :creator_id, :integer
  end

  def self.down
    remove_column :directorates, :creator_id
  end
end
