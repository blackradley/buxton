class CreateDirectorates < ActiveRecord::Migration
  def self.up
    create_table :directorates do |t|
      t.column :organisation_id, :integer
      t.column :name, :string
    end
    add_column :functions, :directorate_id, :integer
  end

  def self.down
    drop_table :directorates
    remove_column :functions, :directorate_id
  end
end
