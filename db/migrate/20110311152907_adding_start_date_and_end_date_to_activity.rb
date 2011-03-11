class AddingStartDateAndEndDateToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :start_date, :date
    add_column :activities, :end_date, :date
  end

  def self.down
    remove_column :activities, :start_date
    remove_column :activities, :end_date
  end
end
