class MakingPasskeyUnique < ActiveRecord::Migration
  def self.up
	change_column :users, :passkey, :string, :unique => true
  end

  def self.down
	 change_column :users, :passkey, :string, :unique => false 
  end
end
