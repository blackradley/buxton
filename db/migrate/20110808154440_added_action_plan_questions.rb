class AddedActionPlanQuestions < ActiveRecord::Migration
  def self.up
    add_column :issues, :recommendations, :text
    add_column :issues, :monitoring, :text
    add_column :issues, :outcomes, :text
  end

  def self.down
    remove_column :issues, :recommendations
    remove_column :issues, :monitoring
    remove_column :issues, :outcomes
  end
end
