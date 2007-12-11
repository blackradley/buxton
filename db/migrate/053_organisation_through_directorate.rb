class OrganisationThroughDirectorate < ActiveRecord::Migration
  def self.up
    remove_column :activities, :organisation_id    
  end

  def self.down
    add_column :activities, :organisation_id, :integer
  end
end