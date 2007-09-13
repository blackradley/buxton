#  
# $URL$ 
# 
# $Rev$
# 
# $Author$
# 
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve
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
    
    $NO_ANSWER = 'Not answered yet'
#   Existing/Proposed
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 15,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Proposed',
    :value => 1,
    :weight => 15,
    :description => 'Proposed',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Existing',
    :value => 2,
    :weight => 5,
    :description => 'Existing',
    :display_order => 2)

    # Yes/No
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 5,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Yes',
    :value => 1,
    :weight => 5,
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'No',
    :value => 2,
    :weight => 5,
    :description => 'No',
    :display_order => 2)
    
#   Amount of impact
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'None',
    :value => 1,
    :weight => 1,
    :description => 'None',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Small minority',
    :value => 2,
    :weight => 5,
    :description => 'Small minority',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Significant minority',
    :value => 3,
    :weight => 5,
    :description => 'Significant minority',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'About half',
    :value => 4,
    :weight => 5,
    :description => 'About half',
    :display_order => 4)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Majority',
    :value => 5,
    :weight => 5,
    :description => 'Majority',
    :display_order => 5)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Substantial majority',
    :value => 6,
    :weight => 5,
    :description => 'Substantial majority',
    :display_order => 6)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'All',
    :value => 7,
    :weight => 5,
    :description => 'All',
    :display_order => 7)
    
    # Level of impact
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 15,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'None',
    :value => 1,
    :weight => 5,
    :description => 'None at all',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Limited',
    :value => 2,
    :weight => 10,
    :description => 'Some impact',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Significant',
    :value => 3,
    :weight => 15,
    :description => 'Significant impact',
    :display_order => 3)
   
  end

  def self.down
    drop_table :look_ups
  end
end
