class AddingExtraOrganisationText < ActiveRecord::Migration
  def self.up
    add_column :organisations, :directorate_term, :string
    add_column :organisations, :strategy_text_selection, :integer, :default => 0
  end

  def self.down
    remove_column :organisations, :directorate_term
    remove_column :organisations, :strategy_text_selection
  end
end
