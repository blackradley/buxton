#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class RenamingTimescales < ActiveRecord::Migration
  def self.up
    change_column :issues, :timescales, :text, :default => ""
  end

  def self.down
    change_column :issues, :timescales, :integer, :default => 0
  end
end
