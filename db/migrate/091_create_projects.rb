class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :organisation_id
      t.string :name
      t.integer :activity_project_id
      t.timestamps
    end
    create_table :activities_projects, :id => false do |t|
      t.integer :activity_id
      t.integer :project_id
    end
    add_column :activities, :activity_project_id, :integer
  end

  def self.down
    drop_table :projects
    drop_table :activities_projects
    remove_column :activities, :activity_project_id
  end
end
