class AddingChangeFieldsToQuestion < ActiveRecord::Migration
  def self.up
    add_column :activities, :previous_activity_id, :integer
  end

  def self.down
    remove_column :activities, :previous_activity_id
  end
end
