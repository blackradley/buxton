class AddingQcOfficerToEa < ActiveRecord::Migration
  def self.up
    # add_column :activities, :qc_officer_id, :integer
    # add_column :activities, :undergone_qc, :boolean, :default => false
    Activity.reset_column_information
    Activity.all.each do |a|
      a.update_attributes!(:qc_officer_id => User.live.first)
    end
  end

  def self.down
    remove_column :activities, :qc_officer_id
    remove_column :activities, :undergone_qc
  end
end
