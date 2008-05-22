#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingProjectManager < ActiveRecord::Migration
  def self.up
    add_column :users, :project_id, :integer
    add_column :strategies, :project_id, :integer
  end

  def self.down
    remove_column :users, :project_id
    remove_column :strategies, :project_id
  end
end
