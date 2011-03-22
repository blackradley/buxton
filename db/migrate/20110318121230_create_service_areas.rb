class CreateServiceAreas < ActiveRecord::Migration
  def self.up
    create_table :service_areas, :force => true do |t|
      t.column :directorate_id, :integer
      t.column :approver_id, :integer
      t.column :name, :string
      t.column :retired, :boolean, :default => false
    end
  end

  def self.down
    drop_table :service_areas
  end
end
