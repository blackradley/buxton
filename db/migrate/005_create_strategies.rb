class CreateStrategies < ActiveRecord::Migration
  def self.up
    create_table :strategies, :force => true do |t|
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer      
    end
  end

  def self.down
    drop_table :strategies
  end
end
