class AddServiceAreaToEinAs < ActiveRecord::Migration
  def self.up
    add_column :activities, :service_area_id, :integer
    
  end

  def self.down
    remove_column :activities, :service_area_id
  end
end
