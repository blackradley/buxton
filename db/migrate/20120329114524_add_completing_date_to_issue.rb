class AddCompletingDateToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :completing, :date
  end

  def self.down
    remove_column :issues, :completing
  end
end
