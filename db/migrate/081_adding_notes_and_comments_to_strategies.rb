#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingNotesAndCommentsToStrategies < ActiveRecord::Migration
  def self.up
    add_column :notes, :activity_strategy_id, :integer
    add_column :comments, :activity_strategy_id, :integer
  end

  def self.down
    remove_column :notes, :activity_strategy_id, :integer
    remove_column :comments, :activity_strategy_id, :integer
  end
end
