class AddingStrandToIssues < ActiveRecord::Migration
  def self.up
	add_column :issues, :strand, :text
  end

  def self.down
	remove_column :issues, :strand, :text
  end
end
