class AddingStartedDate < ActiveRecord::Migration
  def self.up
    add_column :activities, :actual_start_date, :date
  end

  def self.down
     remove_column :activities, :actual_start_date, :date
  end
end
