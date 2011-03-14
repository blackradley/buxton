class AddDeviseColumns < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.lockable
    end
  end

  def self.down
    remove_column :users, :locked_at
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
  end
end
