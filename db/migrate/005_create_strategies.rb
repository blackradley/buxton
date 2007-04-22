#  
# * $URL$
# * $Rev$
# * $Author$
# * $Date$
#
# Copyright © 2007 Black Radley Limited. All rights reserved. 
#
class CreateStrategies < ActiveRecord::Migration
  def self.up
    create_table :strategies, :force => true do |t|
      t.column :organisation_id, :integer
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer  
      t.column :created_on,      :timestamp
      t.column :updated_on,      :timestamp    
    end
  end

  def self.down
    drop_table :strategies
  end
end
