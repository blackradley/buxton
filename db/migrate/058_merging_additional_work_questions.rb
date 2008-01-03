class MergingAdditionalWorkQuestions < ActiveRecord::Migration
  def self.up
    remove_column :activities, :additional_work_age_5
    rename_column :activities, :additional_work_age_6, :additional_work_age_5
    rename_column :activities, :additional_work_age_7, :additional_work_age_6
    
    remove_column :activities, :additional_work_disability_5
    rename_column :activities, :additional_work_disability_6, :additional_work_disability_5
    rename_column :activities, :additional_work_disability_7, :additional_work_disability_6
    rename_column :activities, :additional_work_disability_8, :additional_work_disability_7
    rename_column :activities, :additional_work_disability_9, :additional_work_disability_8
    rename_column :activities, :additional_work_disability_10, :additional_work_disability_9
    
    remove_column :activities, :additional_work_sexual_orientation_5
    rename_column :activities, :additional_work_sexual_orientation_6, :additional_work_sexual_orientation_5
    rename_column :activities, :additional_work_sexual_orientation_7, :additional_work_sexual_orientation_6
    
    remove_column :activities, :additional_work_faith_5
    rename_column :activities, :additional_work_faith_6, :additional_work_faith_5
    rename_column :activities, :additional_work_faith_7, :additional_work_faith_6
    
    remove_column :activities, :additional_work_race_5
    rename_column :activities, :additional_work_race_6, :additional_work_race_5
    rename_column :activities, :additional_work_race_7, :additional_work_race_6
    
    remove_column :activities, :additional_work_gender_5
    rename_column :activities, :additional_work_gender_6, :additional_work_gender_5
  end

  def self.down
    rename_column :activities, :additional_work_gender_5, :additional_work_gender_6
    add_column :activities, :additional_work_gender_5, :integer, :default => 0
    
    rename_column :activities, :additional_work_disability_5, :additional_work_disability_6
    rename_column :activities, :additional_work_disability_6, :additional_work_disability_7
    rename_column :activities, :additional_work_disability_7, :additional_work_disability_8
    rename_column :activities, :additional_work_disability_8, :additional_work_disability_9
    rename_column :activities, :additional_work_disability_9, :additional_work_disability_10
    add_column :activities, :additional_work_disability_5, :integer, :default => 0
    
    rename_column :activities, :additional_work_faith_5, :additional_work_faith_6
    rename_column :activities, :additional_work_faith_6, :additional_work_faith_7
    add_column :activities, :additional_work_faith_5, :integer, :default => 0
    
    rename_column :activities, :additional_work_sexual_orientation_5, :additional_work_sexual_orientation_6
    rename_column :activities, :additional_work_sexual_orientation_6, :additional_work_sexual_orientation_7
    add_column :activities, :additional_work_sexual_orientation_5, :integer, :default => 0
    
    rename_column :activities, :additional_work_race_5, :additional_work_race_6
    rename_column :activities, :additional_work_race_6, :additional_work_race_7
    add_column :activities, :additional_work_race_5, :integer, :default => 0
    
    rename_column :activities, :additional_work_age_5, :additional_work_age_6
    rename_column :activities, :additional_work_age_6, :additional_work_age_7
    add_column :activities, :additional_work_age_5, :integer, :default => 0
  end
end
