class ActivityRefNo < ActiveRecord::Migration
  def self.up
    add_column :activities, :ref_no, :string
  end

  def self.down
    remove_column :activities, :ref_no
  end
end
