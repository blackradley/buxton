class AddingTrainingStatusAndAdminToUsers < ActiveRecord::Migration
  def self.up
    drop_table :admins
    
    add_column :users, :type, :string
    add_column :users, :trained, :boolean
    add_column :users, :retired, :boolean
    add_column :users, :locked, :boolean
  end

  def self.down
    create_table(:admins, :force => true) do |t|
      t.database_authenticatable :null => false
      t.trackable
      t.timestamps
    end
    add_index :admins, :email,                :unique => true
    
    remove_column :users, :type
    remove_column :users, :trained
    remove_column :users, :retired
    remove_column :users, :locked
  end
end
