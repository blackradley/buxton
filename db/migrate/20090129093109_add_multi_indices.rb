class AddMultiIndices < ActiveRecord::Migration
  def self.up
    add_index :questions, [:activity_id, :name, :needed, :completed]
    add_index :activities, [:directorate_id, :approved]
    change_column :help_texts, :question_name, :string, :limit => 40
    add_index :help_texts, :question_name
  end

  def self.down
    remove_index :questions, [:activity_id, :name, :needed, :completed]
    remove_index :activities, [:directorate_id, :approved]
    remove_index :help_texts, :question_name
    change_column :help_texts, :question_name, :text
  end
end
