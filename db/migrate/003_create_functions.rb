#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved.
#
class CreateFunctions < ActiveRecord::Migration
  def self.up
    create_table :functions, :force => true do |t|
      t.column :user_id,                 :integer
      t.column :organisation_id,         :integer
      t.column :name,                    :string
      t.column :existence_status,        :integer,  :default => 0
      t.column :impact_service_users,    :integer,  :default => 0
      t.column :impact_staff,            :integer,  :default => 0
      t.column :impact_supplier_staff,   :integer,  :default => 0
      t.column :impact_partner_staff,    :integer,  :default => 0
      t.column :impact_employees,        :integer,  :default => 0
      t.column :good_gender,             :integer,  :default => 0
      t.column :good_race,               :integer,  :default => 0
      t.column :good_disability,         :integer,  :default => 0
      t.column :good_faith,              :integer,  :default => 0
      t.column :good_sexual_orientation, :integer,  :default => 0
      t.column :good_age,                :integer,  :default => 0
      t.column :bad_gender,              :integer,  :default => 0
      t.column :bad_race ,               :integer,  :default => 0
      t.column :bad_disability,          :integer,  :default => 0
      t.column :bad_faith,               :integer,  :default => 0
      t.column :bad_sexual_orientation,  :integer,  :default => 0
      t.column :bad_age,                 :integer,  :default => 0
      t.column :approved,                :integer,  :default => 0
      t.column :approver,                :string
      t.column :created_on,              :timestamp
      t.column :updated_on,              :timestamp
      t.column :updated_by,              :string
      t.column :deleted_on,              :timestamp
    end
  end

  def self.down
    drop_table :functions
  end
end
