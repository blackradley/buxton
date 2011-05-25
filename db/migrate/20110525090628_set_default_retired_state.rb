class SetDefaultRetiredState < ActiveRecord::Migration
  def self.up
    change_column :users, :retired, :boolean, :default => false
    User.all.each do |user|
      user.update_attribute(:retired, false) if user.retired.nil?
    end
  end

  def self.down
  end
end
