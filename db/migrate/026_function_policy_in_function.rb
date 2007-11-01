#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class FunctionPolicyInFunction < ActiveRecord::Migration
  def self.up
  	add_column :functions, :function_policy, :integer, :default => 0
  end

  def self.down
    remove_column :functions, :function_policy
  end
end
