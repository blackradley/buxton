#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
# The user table only contains only the email and key.
# These are effectively the username and password, well
# actually the key is both the username and password 
# combined and the email is used to deliver the key to
# the user. 
# 
# The user type is kept as an integer, this is a bit naff
# and it could be determined implicitly from the foreign
# keys in the other tables.  But this becomes a bit of a 
# hassle to search the other tables or to create a view 
# which gives the user type.
# 
# They key is called "passkey" because key is a reserved
# word in MySql and somethings this causes a problem, 
# particularly if you use rails_sql_views
# 
class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :user_type,     :integer,  :default => 3
      t.column :passkey,       :string
      t.column :email,         :string
      t.column :created_on,    :timestamp
      t.column :updated_on,    :timestamp
      t.column :reminded_on,   :timestamp
      t.column :deleted_on,    :timestamp
    end
    add_index :users, :passkey
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
