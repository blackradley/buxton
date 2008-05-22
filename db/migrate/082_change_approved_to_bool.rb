#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class ChangeApprovedToBool < ActiveRecord::Migration
  def self.up
    change_column :activities, :approved, :boolean, :default => false
  end

  def self.down
    change_column :activities, :approved, :integer, :default => 0    
  end
end