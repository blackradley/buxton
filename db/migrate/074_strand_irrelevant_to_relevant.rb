class StrandIrrelevantToRelevant < ActiveRecord::Migration
  def self.up
    change_column :activities, :gender_irrelevant, :boolean, :default => true
    change_column :activities, :sexual_orientation_irrelevant, :boolean, :default => true
    change_column :activities, :race_irrelevant, :boolean, :default => true
    change_column :activities, :age_irrelevant, :boolean, :default => true
    change_column :activities, :disability_irrelevant, :boolean, :default => true
    change_column :activities, :faith_irrelevant, :boolean, :default => true
    
    rename_column :activities, :gender_irrelevant, :gender_relevant
    rename_column :activities, :sexual_orientation_irrelevant, :sexual_orientation_relevant
    rename_column :activities, :race_irrelevant, :race_relevant
    rename_column :activities, :age_irrelevant, :age_relevant
    rename_column :activities, :disability_irrelevant, :disability_relevant
    rename_column :activities, :faith_irrelevant, :faith_relevant
  end

  def self.down
    rename_column :activities, :gender_relevant, :gender_irrelevant
    rename_column :activities, :sexual_orientation_relevant, :sexual_orientation_irrelevant
    rename_column :activities, :race_relevant, :race_irrelevant
    rename_column :activities, :age_relevant, :age_irrelevant
    rename_column :activities, :disability_relevant, :disability_irrelevant
    rename_column :activities, :faith_relevant, :faith_irrelevant
    
    change_column :activities, :gender_irrelevant, :boolean, :default => false
    change_column :activities, :sexual_orientation_irrelevant, :boolean, :default => false
    change_column :activities, :race_irrelevant, :boolean, :default => false
    change_column :activities, :age_irrelevant, :boolean, :default => false
    change_column :activities, :disability_irrelevant, :boolean, :default => false
    change_column :activities, :faith_irrelevant, :boolean, :default => false
  end
end
