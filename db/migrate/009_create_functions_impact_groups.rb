#  
# $URL: http://svn3.cvsdude.com/BlackRadley/buxton/trunk/db/migrate/001_create_users.rb $
# $Rev: 88 $
# $Author: BlackRadleyJoe $
# $Date: 2007-04-22 19:35:53 +0100 (Sun, 22 Apr 2007) $
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class CreateFunctionsImpactGroups < ActiveRecord::Migration
  def self.up
    create_table :functions_impact_groups, :force => true do |t|
      t.column :function_id,        :integer
      t.column :impact_group_id,    :integer
      t.column :impact_group_value, :integer
    end
  end

  def self.down
    drop_table :functions_impact_groups
  end
end
