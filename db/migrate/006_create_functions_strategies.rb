class CreateFunctionsStrategies < ActiveRecord::Migration
  def self.up
    create_table :functions_strategies, :force => true do |t|
      t.column :function_id,     :integer
      t.column :strategy_id,     :timestamp    
    end
  end

  def self.down
    drop_table :functions_strategies
  end
end
