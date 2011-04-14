class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users, :force => true) do |t|
      t.database_authenticatable :null => false
      t.encryptable
      t.text :roles
      t.trackable
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    
    create_table(:admins, :force => true) do |t|
      t.database_authenticatable :null => false
      t.encryptable
      t.trackable
      t.timestamps
    end
    add_index :admins, :email,                :unique => true
    
    add_column :activities, :activity_manager_id, :integer
    add_column :activities, :activity_approver_id, :integer
  end


  def self.down
    drop_table :users
    drop_table :admins
  end
end
