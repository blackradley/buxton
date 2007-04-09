class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :Users, :force => true do |t|
      t.column :key,         :string
      t.column :email,       :string
    end
  end

  def self.down
    drop_table :Users
  end
end
