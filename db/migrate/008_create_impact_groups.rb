#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
class CreateImpactGroups < ActiveRecord::Migration
  def self.up
    create_table :impact_groups, :force => true do |t|
      t.column :organisation_id, :integer
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer  
      t.column :created_on,      :timestamp
      t.column :updated_on,      :timestamp   
    end
  end

  def self.down
    drop_table :impact_groups
  end
end
