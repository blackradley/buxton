class MovingCesQuestion < ActiveRecord::Migration
  def self.up
    rename_column :activities, :purpose_overall_10, :ces_question
  end

  def self.down
    rename_column :activities, :ces_question, :purpose_overall_10
  end
end
