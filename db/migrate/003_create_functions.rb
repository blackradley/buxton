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
      t.column :is_proposed,             :integer
      t.column :good_ethnic,             :integer,  :default => 0
      t.column :good_ability,            :integer,  :default => 0
      t.column :good_gender,             :integer,  :default => 0
      t.column :good_sexual_orientation, :integer,  :default => 0
      t.column :good_faith,              :integer,  :default => 0
      t.column :good_age,                :integer,  :default => 0
      t.column :bad_ethnic ,             :integer,  :default => 0
      t.column :bad_ability,             :integer,  :default => 0
      t.column :bad_gender,              :integer,  :default => 0
      t.column :bad_sexual_orientation,  :integer,  :default => 0
      t.column :bad_faith,               :integer,  :default => 0
      t.column :bad_age,                 :integer,  :default => 0
      t.column :is_approved,             :integer
      t.column :created_on,              :timestamp
      t.column :updated_on,              :timestamp
      t.column :deleted_on,              :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
