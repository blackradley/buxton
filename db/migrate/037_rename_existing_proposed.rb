#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class RenameExistingProposed < ActiveRecord::Migration
  def self.up
	rename_column :functions, :purpose_overall_1, :existing_proposed
  end

  def self.down
	  rename_column :functions,  :existing_proposed,:purpose_overall_1
  end
end
