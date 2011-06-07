class CreateTaskGroups < ActiveRecord::Migration
  def self.up
    create_table :task_group_memberships do |t|
      t.integer :user_id
      t.integer :activity_id
      t.timestamps
    end
  end

  def self.down
    drop_table :task_group_memberships
  end
end
