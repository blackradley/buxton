#  
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserve 
#
class CreateFunctionStrategies < ActiveRecord::Migration
  def self.up
    create_table :function_strategies, :force => true do |t|
      t.column :function_id,        :integer
      t.column :strategy_id,        :integer
      t.column :strategy_response,  :integer
    end
    
    # Strategy responses for Birminham
    birmingham = Organisation.find(:first, :conditions => "style = 'birmingham'")
    # Birminham's first function
    first_function = birmingham.functions.first
    birmingham.strategies.each do |function_strategy|
      function_response = first_function.function_strategies.find_or_create_by_strategy_id(function_strategy.id)
      function_response.strategy_response = (rand + 1).round
      function_response.save
    end    
    # Birminham's last function
    last_function = birmingham.functions.last
    birmingham.strategies.each do |function_strategy|
      function_response = last_function.function_strategies.find_or_create_by_strategy_id(function_strategy.id)
      function_response.strategy_response = (rand + 1).round
      function_response.save
    end
  end
  
  def self.down
    drop_table :function_strategies
  end
end
