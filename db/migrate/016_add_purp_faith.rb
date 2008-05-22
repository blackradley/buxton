#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class AddPurpFaith < ActiveRecord::Migration
  def self.up
    add_column :functions, :purpose_faith_1, :integer, :default => 0
  	add_column :functions, :purpose_faith_2, :text
  end

  def self.down
  	remove_column :functions, :purpose_faith_1, :integer, :default => 0
  	remove_column :functions, :purpose_faith_2, :text
  end
end
