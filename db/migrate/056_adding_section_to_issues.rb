#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingSectionToIssues < ActiveRecord::Migration
  def self.up
    add_column :issues, :section, :text
  end

  def self.down
    remove_column :issues, :section, :text
  end
end

