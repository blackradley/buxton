class AddingQuestionNeededFlag < ActiveRecord::Migration
  def self.up
    add_column :questions, :needed, :boolean, :default => true
  end

  def self.down
    remove_column :questions, :needed
  end
end
