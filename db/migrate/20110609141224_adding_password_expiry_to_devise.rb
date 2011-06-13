class AddingPasswordExpiryToDevise < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.password_expirable
    end
    User.reset_column_information
    User.all.each do |u|
      u.update_attributes(:password_changed_at => Time.now)
    end
  end

  def self.down
  end
end
