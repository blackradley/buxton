#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
class CreateLookUps < ActiveRecord::Migration
  def self.up
    create_table :look_ups, :force => true do |t|
      t.column :look_up_type,    :integer
      t.column :name,            :string
      t.column :value,           :integer
      t.column :weight,          :integer
      t.column :description,     :string
      t.column :display_order,   :integer
    end   
  end

  def self.down
    drop_table :look_ups
  end
end
