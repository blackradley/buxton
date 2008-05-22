#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingApprovedAt < ActiveRecord::Migration
  def self.up
    add_column :activities, :approved_on, :timestamp
  end

  def self.down
    remove_column :activities, :approved_on, :timestamp
  end
end
