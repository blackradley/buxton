class ConvertingImpactThreeToTextFromString < ActiveRecord::Migration
  def self.up
    change_column :activities, :impact_gender_3, :text
    change_column :activities, :impact_age_3, :text
    change_column :activities, :impact_disability_3, :text
    change_column :activities, :impact_faith_3, :text
    change_column :activities, :impact_race_3, :text
    change_column :activities, :impact_sexual_orientation_3, :text
  end

  def self.down
    change_column :activities, :impact_gender_3, :string
    change_column :activities, :impact_age_3, :string
    change_column :activities, :impact_disability_3, :string
    change_column :activities, :impact_faith_3, :string
    change_column :activities, :impact_race_3, :string
    change_column :activities, :impact_sexual_orientation_3, :string
  end
end
