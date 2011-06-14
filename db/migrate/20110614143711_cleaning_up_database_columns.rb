class CleaningUpDatabaseColumns < ActiveRecord::Migration
  def self.up
    remove_column :activities, :directorate_id
    remove_column :activities, :ref_no
  end

  def self.down
    add_column :activities, :directorate_id, :integer
    add_column :activities, :ref_no, :string
  end
end
