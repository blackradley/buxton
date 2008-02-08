class AddCesLink < ActiveRecord::Migration
  def self.up
  	add_column :organisations, :ces_link, :string
  end

  def self.down
  	remove_column :organisations, :ces_link, :string
  end
end
