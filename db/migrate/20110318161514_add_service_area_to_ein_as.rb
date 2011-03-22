class AddServiceAreaToEinAs < ActiveRecord::Migration
  def self.up
    add_column :activities, :service_area_id, :integer
    
    Activity.all.each do |activity|
      activity.service_area_id = activity.directorate.service_areas.first.id
      activity.save!
    end
    
  end

  def self.down
    remove_column :activities, :service_area_id
  end
end
