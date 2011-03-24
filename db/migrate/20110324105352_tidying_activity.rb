class TidyingActivity < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.rename :existing_proposed, :activity_status
      t.rename :function_policy, :activity_type
      t.remove :approved
      t.remove :gender_percentage_importance
      t.remove :race_percentage_importance
      t.remove :disability_percentage_importance
      t.remove :sexual_orientation_percentage_importance
      t.remove :faith_percentage_importance
      t.remove :age_percentage_importance         
      t.remove :purpose_overall_11
      t.remove :purpose_overall_12
      t.remove :percentage_importance
      t.remove :ces_question
      t.change :review_on, :date
      t.column :approved, :boolean
      t.column :submitted, :boolean
    end
  end

  def self.down 
    change_table :activities do |t|
      t.rename :activity_status, :existing_proposed
      t.rename :activity_type, :function_policy
      t.remove :approved
      t.column :gender_percentage_importance, :integer
      t.column :race_percentage_importance, :integer
      t.column :disability_percentage_importance, :integer
      t.column :sexual_orientation_percentage_importance, :integer
      t.column :faith_percentage_importance, :integer
      t.column :age_percentage_importance , :integer
      t.column :purpose_overall_11, :integer
      t.column :purpose_overall_12, :integer
      t.column :percentage_importance, :integer
      t.column :ces_question, :integer
      t.change :review_on, :string
      t.column :approved, :string
      t.remove :submitted
    end
  end
end
