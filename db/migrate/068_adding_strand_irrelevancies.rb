#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingStrandIrrelevancies < ActiveRecord::Migration
  def self.up
    add_column :activities, :gender_irrelevant, :boolean, :default => false
    add_column :activities, :sexual_orientation_irrelevant, :boolean, :default => false
    add_column :activities, :age_irrelevant, :boolean, :default => false
    add_column :activities, :faith_irrelevant, :boolean, :default => false
    add_column :activities, :disability_irrelevant, :boolean, :default => false
    add_column :activities, :race_irrelevant, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :gender_irrelevant
    remove_column :activities, :sexual_orientation_irrelevant
    remove_column :activities, :age_irrelevant
    remove_column :activities, :faith_irrelevant
    remove_column :activities, :disability_irrelevant
    remove_column :activities, :race_irrelevant
  end
end
