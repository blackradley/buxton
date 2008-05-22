#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class RemovingUnneededActivityColumns < ActiveRecord::Migration
  def self.up
    remove_column :activities, :overall_completed_strategies
    remove_column :activities, :overall_completed_questions
    remove_column :activities, :impact
    remove_column :activities, :overall_started
    remove_column :activities, :overall_completed_issues
  end

  def self.down
    add_column :activities, :overall_completed_strategies, :boolean, :default => false
    add_column :activities, :overall_completed_questions, :boolean, :default => false
    add_column :activities, :overall_completed_issues, :boolean, :default => false
    add_column :activities, :impact, :integer
    add_column :activities, :overall_started, :boolean, :default => false
  end
end
