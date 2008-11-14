class MakeStrategyTextLarger < ActiveRecord::Migration
  def self.up
    change_column :strategies, :description, :text
  end

  def self.down
    change_column :strategies, :description, :string
  end
end
