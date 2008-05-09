class CreateOrganisationStrategies < ActiveRecord::Migration
  def self.up
    add_column :strategies, :type, :string
    add_column :strategies, :directorate_id, :integer
  end

  def self.down
    remove_column :strategies, :type
    remove_column :strategies, :directorate_id
  end
end
