class ChangingIssueStrandType < ActiveRecord::Migration
  def self.up
	change_column :issues, :strand, :string
  end

  def self.down
	change_column :issues, :strand, :text
  end
end
