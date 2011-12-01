class LinkingIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :parent_issue_id, :integer
  end

  def self.down
    remove_column :issues, :parent_issue_id
  end
end
