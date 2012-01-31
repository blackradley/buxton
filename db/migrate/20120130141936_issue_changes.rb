class IssueChanges < ActiveRecord::Migration
  def self.up
    remove_column :issues, :timescales
    remove_column :issues, :lead_officer
    add_column :issues, :timescales, :date
    add_column :issues, :lead_officer_id, :integer
  end

  def self.down
    remove_column :issues, :timescales
    remove_column :issues, :lead_officer_id
    add_column :issues, :timescales, :text
    add_column :issues, :lead_officer, :text
  end
end
