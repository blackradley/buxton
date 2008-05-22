#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class AddingStrandToIssues < ActiveRecord::Migration
  def self.up
	add_column :issues, :strand, :text
  end

  def self.down
	remove_column :issues, :strand, :text
  end
end
