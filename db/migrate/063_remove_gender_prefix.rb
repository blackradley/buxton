class RemoveGenderPrefix < ActiveRecord::Migration
  def self.up
    rename_column :activities, :gender_impact, :impact
    rename_column :activities, :gender_percentage_importance, :percentage_importance
  end

  def self.down
    rename_column :activities, :impact, :gender_impact
    rename_column :activities, :percentage_importance, :gender_percentage_importance
  end
end
