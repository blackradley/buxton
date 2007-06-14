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
    
    # Five functions for birmingham
    birmingham = Organisation.find(:first, :conditions => "style = 'birmingham'")
    # Community Strategy
    user = User.create(:user_type => User::TYPE[:functional],
      :email => 'Peter_Latchford@blackradley.com')
    Function.create(:user_id => user.id,
      :organisation_id => birmingham.id,
      :name => 'Community Strategy',
      :existence_status => 1,
      :impact_service_users => 3,
      :impact_staff => 1,
      :impact_supplier_staff => 2,
      :impact_partner_staff => 3,
      :impact_employees => 4,
      :good_gender => 1,
      :good_race => 1,
      :good_disability => 3,
      :good_faith => 1,
      :good_sexual_orientation => 1,
      :good_age => 1,
      :bad_gender => 1,
      :bad_race => 1,
      :bad_disability => 1,
      :bad_faith => 2,
      :bad_sexual_orientation => 1,
      :bad_age => 1,
      :approved => 1,
      :approver => 'Iain Wilkinson') 
    user = User.create(:user_type => User::TYPE[:functional],
      :email => 'Iain_Wilkinson@blackradley.com')
    # Publications
    Function.create(:user_id => user.id,
      :organisation_id => birmingham.id,
      :name => 'Publications',
      :existence_status => 1,
      :impact_service_users => 3,
      :impact_staff => 1,
      :impact_supplier_staff => 2,
      :impact_partner_staff => 3,
      :impact_employees => 4,
      :good_gender => 1,
      :good_race => 1,
      :good_disability => 3,
      :good_faith => 1,
      :good_sexual_orientation => 1,
      :good_age => 1,
      :bad_gender => 1,
      :bad_race => 1,
      :bad_disability => 1,
      :bad_faith => 2,
      :bad_sexual_orientation => 1,
      :bad_age => 1,
      :approved => 0,
      :approver => 'Peter Latchford')   
    # Meals on Wheels
    user = User.create(:user_type => User::TYPE[:functional],
      :email => 'Joe_Collins@blackradley.com')
    Function.create(:user_id => user.id,
      :organisation_id => birmingham.id,
      :name => 'Meals on Wheels',
      :existence_status => 2,
      :impact_service_users => 0,
      :impact_staff => 3,
      :impact_supplier_staff => 2,
      :impact_partner_staff => 0,
      :impact_employees => 0,
      :good_gender => 0,
      :good_race => 1,
      :good_disability => 0,
      :good_faith => 0,
      :good_sexual_orientation => 0,
      :good_age => 0,
      :bad_gender => 1,
      :bad_race => 0,
      :bad_disability => 0,
      :bad_faith => 1,
      :bad_sexual_orientation => 0,
      :bad_age => 0,
      :approved => 0,
      :approver => 'Iain Wilkinson')
    user = User.create(:user_type => User::TYPE[:functional],
      :email => 'drbollins@hotmail.com')
    Function.create(:user_id => user.id,
      :organisation_id => birmingham.id,
      :name => 'Drugs and Alcohol',
      :existence_status => 1,
      :impact_service_users => 0,
      :impact_staff => 0,
      :impact_supplier_staff => 0,
      :impact_partner_staff => 0,
      :impact_employees => 0,
      :good_gender => 0,
      :good_race => 0,
      :good_disability => 0,
      :good_faith => 0,
      :good_sexual_orientation => 0,
      :good_age => 0,
      :bad_gender => 0,
      :bad_race => 0,
      :bad_disability => 0,
      :bad_faith => 0,
      :bad_sexual_orientation => 0,
      :bad_age => 0,
      :approved => 0,
      :approver => '')
    user = User.create(:user_type => User::TYPE[:functional],
      :email => 'Peter_Latchford@blackradley.com')
    Function.create(:user_id => user.id,
      :organisation_id => birmingham.id,
      :name => 'Occupational Therapy',
      :existence_status => 2,
      :impact_service_users => 3,
      :impact_staff => 1,
      :impact_supplier_staff => 2,
      :impact_partner_staff => 3,
      :impact_employees => 4,
      :good_gender => 1,
      :good_race => 1,
      :good_disability => 3,
      :good_faith => 1,
      :good_sexual_orientation => 1,
      :good_age => 1,
      :bad_gender => 1,
      :bad_race => 1,
      :bad_disability => 1,
      :bad_faith => 3,
      :bad_sexual_orientation => 1,
      :bad_age => 1,
      :approved => 1,
      :approver => 'Iain Wilkinson')
  end

  def self.down
    drop_table :functions
  end
end
