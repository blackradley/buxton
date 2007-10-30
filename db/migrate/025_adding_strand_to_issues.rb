#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class AddingStrandToIssues < ActiveRecord::Migration
  def self.up
	add_column :issues, :strand, :text
  end

  def self.down
	remove_column :issues, :strand, :text
  end
end
