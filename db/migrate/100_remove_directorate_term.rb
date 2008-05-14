class RemoveDirectorateTerm < ActiveRecord::Migration
  def self.up
    remove_column :organisations, :directorate_term
  end

  def self.down
    add_column :organisations, :directorate_term, :string
  end
end
