class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :activities, :directorate_id
    add_index :activities_projects, :activity_id
    add_index :activities_projects, :project_id
    add_index :activity_strategies, :activity_id
    add_index :activity_strategies, :strategy_id
    add_index :comments, :question_id
    add_index :comments, :activity_strategy_id
    add_index :directorates, :organisation_id
    add_index :issues, :activity_id
    add_index :notes, :question_id
    add_index :notes, :activity_strategy_id
    add_index :organisation_terminologies, :organisation_id
    add_index :organisation_terminologies, :terminology_id
    add_index :projects, :organisation_id
    add_index :questions, :activity_id
    add_index :strategies, :organisation_id
    add_index :strategies, :directorate_id
    add_index :strategies, :project_id
    add_index :users, :organisation_id
    add_index :users, :directorate_id
    add_index :users, :project_id
    
    add_index :activities, :approved
  end

  def self.down
    remove_index :activities, :directorate_id
    remove_index :activities_projects, :activity_id
    remove_index :activities_projects, :project_id
    remove_index :activity_strategies, :activity_id
    remove_index :activity_strategies, :strategy_id
    remove_index :comments, :question_id
    remove_index :comments, :activity_strategy_id
    remove_index :directorates, :organisation_id
    remove_index :issues, :activity_id
    remove_index :notes, :question_id
    remove_index :notes, :activity_strategy_id
    remove_index :organisation_terminologies, :organisation_id
    remove_index :organisation_terminologies, :terminology_id
    remove_index :projects, :organisation_id
    remove_index :questions, :activity_id
    remove_index :strategies, :organisation_id
    remove_index :strategies, :directorate_id
    remove_index :strategies, :project_id
    remove_index :users, :organisation_id
    remove_index :users, :directorate_id
    remove_index :users, :project_id
    
    remove_index :activities, :approved
  end
end
