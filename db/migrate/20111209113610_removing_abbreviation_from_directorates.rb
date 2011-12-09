class RemovingAbbreviationFromDirectorates < ActiveRecord::Migration
  def self.up
    remove_column :directorates, :abbreviation
  end

  def self.down
    add_column :directorates, :abbreviation, :string
  end
end
