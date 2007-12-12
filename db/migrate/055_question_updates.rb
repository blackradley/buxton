class QuestionUpdates < ActiveRecord::Migration
  def self.up
    remove_column :activities, :impact_gender_10
    remove_column :activities, :impact_age_10
    remove_column :activities, :impact_race_10
    remove_column :activities, :impact_disability_10
    remove_column :activities, :impact_sexual_orientation_10
    remove_column :activities, :impact_overall_10
    remove_column :activities, :impact_faith_10
    
    remove_column :activities, :impact_overall_4
    remove_column :activities, :impact_overall_5
    remove_column :activities, :impact_overall_6
    remove_column :activities, :impact_overall_7
    remove_column :activities, :impact_overall_8
    remove_column :activities, :impact_overall_9

    change_column :activities, :impact_gender_5, :text
    change_column :activities, :impact_age_5, :text
    change_column :activities, :impact_faith_5, :text
    change_column :activities, :impact_disability_5, :text
    change_column :activities, :impact_sexual_orientation_5, :text
    change_column :activities, :impact_race_5, :text
    
    change_column :activities, :impact_gender_2, :integer
    change_column :activities, :impact_age_2, :integer
    change_column :activities, :impact_faith_2, :integer
    change_column :activities, :impact_disability_2, :integer
    change_column :activities, :impact_sexual_orientation_2, :integer
    change_column :activities, :impact_race_2, :integer
    change_column :activities, :impact_overall_2, :integer
    
    change_column :activities, :impact_gender_7, :text
    change_column :activities, :impact_age_7, :text
    change_column :activities, :impact_faith_7, :text
    change_column :activities, :impact_disability_7, :text
    change_column :activities, :impact_sexual_orientation_7, :text
    change_column :activities, :impact_race_7, :text
    
  end

  def self.down
  end
end
