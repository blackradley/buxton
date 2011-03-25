class AddingExtraStrands < ActiveRecord::Migration
  def self.up
    add_column :activities, :gender_reassignment_relevant, :boolean
    add_column :activities, :pregnancy_and_maternity_relevant, :boolean
    add_column :activities, :marriage_civil_partnership_relevant, :boolean
  end

  def self.down
    remove_column :activities, :gender_reassignment_relevant
    remove_column :activities, :pregnancy_and_maternity_relevant
    remove_column :activities, :marriage_civil_partnership_relevant
  end
end
