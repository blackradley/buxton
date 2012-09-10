class AddDirectoratesUsersTable < ActiveRecord::Migration
  def self.up
    create_table :directorates_users, :id => false do |t|
      t.integer :directorate_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :directorates_users
  end
end
