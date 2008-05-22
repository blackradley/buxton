#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingDirectorateManager < ActiveRecord::Migration
  def self.up
    add_column :users, :directorate_id, :integer
  end

  def self.down
    remove_column :users, :directorate_id, :integer
  end
end

