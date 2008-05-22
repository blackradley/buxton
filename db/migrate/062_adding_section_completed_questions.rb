#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingSectionCompletedQuestions < ActiveRecord::Migration
  def self.up
    add_column :activities, :purpose_completed, :boolean, :default => false
    add_column :activities, :impact_completed, :boolean, :default => false
    add_column :activities, :consultation_completed, :boolean, :default => false
    add_column :activities, :additional_work_completed, :boolean, :default => false
    add_column :activities, :action_planning_completed, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :purpose_completed
    remove_column :activities, :impact_completed
    remove_column :activities, :consultation_completed
    remove_column :activities, :additional_work_completed
    remove_column :activities, :action_planning_completed
  end
end
