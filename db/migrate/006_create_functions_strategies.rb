#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
class CreateFunctionsStrategies < ActiveRecord::Migration
  def self.up
    create_table :functions_strategies, :force => true do |t|
      t.column :function_id,     :integer
      t.column :strategy_id,     :integer
    end
  end

  def self.down
    drop_table :functions_strategies
  end
end
