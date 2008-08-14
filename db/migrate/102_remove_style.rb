class RemoveStyle < ActiveRecord::Migration
  def self.up
    remove_column :organisations, :style
  end

  def self.down
    add_column :organisations, :style, :string
  end
end
