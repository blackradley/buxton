class AddingCorporateCop < ActiveRecord::Migration
  def self.up
    add_column :users, :corporate_cop, :boolean
  end

  def self.down
    remove_column :users, :corporate_cop
  end
end
