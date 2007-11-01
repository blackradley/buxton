#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class ExistenceStatusAndCreateIssues < ActiveRecord::Migration
  def self.up
    rename_column :functions, :existence_status, :purpose_overall_1	
    create_table :issues do |t|
	    t.column :function_id, :integer
	    t.column :description, :text
	    t.column :actions, :text
	    t.column :timescales, :integer, :default => 0
	    t.column :resources, :text
	    t.column :lead_officer, :text
    end
  end

  def self.down
    rename_column :functions, :purpose_overall_1, :existence_status
    drop_table :issues
  end
end
