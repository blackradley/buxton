#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class ChangingIssueStrandType < ActiveRecord::Migration
  def self.up
	change_column :issues, :strand, :string
  end

  def self.down
	change_column :issues, :strand, :text
  end
end
