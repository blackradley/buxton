#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingTimestampsToDirectorates < ActiveRecord::Migration
  def self.up
    add_column :directorates, :created_on, :timestamp
    add_column :directorates, :updated_on, :timestamp
  end

  def self.down
    remove_column :directorates, :created_on
    remove_column :directorates, :updated_on
  end
end
