class DirectorateAmends < ActiveRecord::Migration
  def self.up
    remove_index :directorates, :organisation_id
    remove_column :directorates, :organisation_id
    add_column :directorates, :cop_id, :integer
    add_column :directorates, :abbreviation, :string
    add_column :directorates, :retired, :boolean, :default => false
  end

  def self.down
    remove_column :directorates, :retired
    remove_column :directorates, :cop_id
    remove_column :directorates, :abbreviation
    add_column :directorates, :organisation_id, :integer
    add_index :directorates, :organisation_id
  end
end
