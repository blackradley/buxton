#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class CreateFunctionStrategies < ActiveRecord::Migration
  def self.up
    create_table :function_strategies, :force => true do |t|
      t.column :function_id,        :integer
      t.column :strategy_id,        :integer
      t.column :strategy_response,  :integer
    end
  end

  def self.down
    drop_table :function_strategies
  end
end
