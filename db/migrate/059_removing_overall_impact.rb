#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class RemovingOverallImpact < ActiveRecord::Migration
  def self.up
    remove_column :activities, :impact_overall_1
    remove_column :activities, :impact_overall_2
    remove_column :activities, :impact_overall_3
  end

  def self.down
    add_column :activities, :impact_overall_1, :integer, :default => 0
    add_column :activities, :impact_overall_2, :integer, :default => 0
    add_column :activities, :impact_overall_3, :text
  end
end
