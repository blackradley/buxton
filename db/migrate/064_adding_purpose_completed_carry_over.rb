#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingPurposeCompletedCarryOver < ActiveRecord::Migration
  def self.up
    add_column :activities, :use_purpose_completed, :boolean, :default => true
  end

  def self.down
    remove_column :activities, :use_purpose_completed
  end
end
