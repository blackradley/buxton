class AddingPasswordExpiryToDevise < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.password_expirable
    end
  end

  def self.down
  end
end
