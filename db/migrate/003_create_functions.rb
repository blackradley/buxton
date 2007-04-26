#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions, :force => true do |t|
      t.column :user_id,                 :integer
      t.column :organisation_id,         :integer
      t.column :name,                    :string
      t.column :is_proposed,             :boolean
      t.column :good_ethnic,             :integer
      t.column :good_ability,            :integer
      t.column :good_gender,             :integer
      t.column :good_sexual_orientation, :integer
      t.column :good_faith,              :integer
      t.column :good_age,                :integer
      t.column :bad_ethnic ,             :integer
      t.column :bad_ability,             :integer
      t.column :bad_gender,              :integer
      t.column :bad_sexual_orientation,  :integer
      t.column :bad_faith,               :integer
      t.column :bad_age,                 :integer
      t.column :is_approved,             :boolean
      t.column :created_on,              :timestamp
      t.column :updated_on,              :timestamp
      t.column :deleted_on,              :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
