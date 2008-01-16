class AddingTopicPercentageImportance < ActiveRecord::Migration
  def self.up
    add_column :activities, :gender_percentage_importance, :integer, :default => 0
    add_column :activities, :race_percentage_importance, :integer, :default => 0
    add_column :activities, :disability_percentage_importance, :integer, :default => 0
    add_column :activities, :sexual_orientation_percentage_importance, :integer, :default => 0
    add_column :activities, :faith_percentage_importance, :integer, :default => 0
    add_column :activities, :age_percentage_importance, :integer, :default => 0
  end

  def self.down
    remove_column :activities, :gender_percentage_importance
    remove_column :activities, :race_percentage_importance
    remove_column :activities, :disability_percentage_importance
    remove_column :activities, :sexual_orientation_percentage_importance
    remove_column :activities, :faith_percentage_importance
    remove_column :activities, :age_percentage_importance
  end
end
