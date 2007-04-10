#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
# 
# The user table only contains only the email and key.
# These are effectively the username and password, well
# actually the key is both the username and password 
# combined and the email is used to deliver the key to
# the user. 
# 
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :key,         :string
      t.column :email,       :string
      t.column :created_on,  :timestamp
      t.column :updated_on,  :timestamp
    end
  end

  def self.down
    drop_table :users
  end
end
