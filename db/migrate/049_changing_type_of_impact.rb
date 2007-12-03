class ChangingTypeOfImpact < ActiveRecord::Migration
  def self.up
    change_column :functions, :impact_gender_2, :text
    change_column :functions, :impact_age_2, :text
    change_column :functions, :impact_race_2, :text
    change_column :functions, :impact_sexual_orientation_2, :text
    change_column :functions, :impact_disability_2, :text
    change_column :functions, :impact_faith_2, :text
  end

  def self.down
    change_column :functions, :impact_gender, :integer
    change_column :functions, :impact_age_2, :integer
    change_column :functions, :impact_race_2, :integer
    change_column :functions, :impact_sexual_orientation_2, :integer
    change_column :functions, :impact_disability_2, :integer
    change_column :functions, :impact_faith_2, :integer
  end
end
