class AddEmptyRefNo < ActiveRecord::Migration
  def self.up
    Activity.find(:all).each do |a|
      a.update_attribute(:ref_no, "")
    end
    change_column :activities, :ref_no, :string, :default => ''
  end
  
  def self.down
  end
end
