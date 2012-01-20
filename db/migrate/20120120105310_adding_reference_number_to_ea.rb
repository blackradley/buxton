class AddingReferenceNumberToEa < ActiveRecord::Migration
  def self.up
  	add_column :activities,  :ref_no, :string 
  	Activity.reset_column_information
  	Activity.all.each do |a|
      if top_parent = a.parent_activity
        top_parent = top_parent.parent_activity while top_parent.parent_activity
        a.update_attributes(:ref_no => "EA#{sprintf("%06d", top_parent.parent_activity.id)}")
      else
  	 	 a.update_attributes(:ref_no => "EA#{sprintf("%06d", a.id)}")
      end
    end
  end

  def self.down
  	remove_column :activities, :ref_no
  end
end
