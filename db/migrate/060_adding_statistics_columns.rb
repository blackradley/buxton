class AddingStatisticsColumns < ActiveRecord::Migration
  def self.up
    add_column :activities, :gender_impact, :integer, :default => 5
    add_column :activities, :gender_percentage_importance, :integer, :default => 0
  end

  def self.down
    remove_column :activities, :gender_impact
    remove_column :activities, :gender_percentage_importance
  end
end
