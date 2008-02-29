class RemovingAddWorkQuestion < ActiveRecord::Migration
  def self.up
    remove_column :activities, :additional_work_gender_5
    remove_column :activities, :additional_work_disability_5
    remove_column :activities, :additional_work_age_5
    remove_column :activities, :additional_work_sexual_orientation_5
    remove_column :activities, :additional_work_faith_5
    remove_column :activities, :additional_work_race_5
  end

  def self.down
    add_column :activities, :additional_work_gender_5, :integer, :default => 0
    add_column :activities, :additional_work_disability_5, :integer, :default => 0
    add_column :activities, :additional_work_age_5, :integer, :default => 0
    add_column :activities, :additional_work_sexual_orientation_5, :integer, :default => 0
    add_column :activities, :additional_work_faith_5, :integer, :default => 0
    add_column :activities, :additional_work_race_5 , :integer, :default => 0
  end
end
