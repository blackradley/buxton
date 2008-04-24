class AddingCesCustomText < ActiveRecord::Migration
  def self.up
    add_column :organisations, :ces_term, :string, :default => "Corporate Equality Scheme"
  end

  def self.down
    remove_column :organisations, :ces_term
  end
end
