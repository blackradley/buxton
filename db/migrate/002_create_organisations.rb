#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright � 2007 Black Radley Limited. All rights reserved. 
#
class CreateOrganisations < ActiveRecord::Migration
  def self.up
    create_table :organisations, :force => true do |t|
      t.column :user_id,               :integer
      t.column :name,                  :string
      t.column :style,                 :string
      t.column :strategy_description,  :text
      t.column :impact_groups_description,  :text
      t.column :created_on,            :timestamp
      t.column :updated_on,            :timestamp
      t.column :deleted_on,            :timestamp
    end
  end

  def self.down
    drop_table :organisations
  end
end
