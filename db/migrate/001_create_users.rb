class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :key,         :string
      t.column :email,       :string
    end
  end

  def self.down
    drop_table :users
  end
end
