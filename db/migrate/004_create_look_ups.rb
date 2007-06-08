#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Limited. All rights reserved. 
#
class CreateLookUps < ActiveRecord::Migration
  def self.up
    create_table :look_ups, :force => true do |t|
      t.column :look_up_type,    :integer
      t.column :value,           :integer
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer
    end
    
    # Yes/No/Not sure
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Not answered yet',
    :value => 0,
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Yes',
    :value => 1,
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'No',
    :value => 2,
    :description => 'No',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Not sure',
    :value => 3,
    :description => 'Not sure',
    :display_order => 3)

    # Agree/Disagree
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Not answered yet',
    :value => 0,
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Disagree strongly',
    :value => 0,
    :description => 'Disagree strongly',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Disagree a little',
    :value => 0,
    :description => 'Disagree a little',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Neither agree or disagree',
    :value => 0,
    :description => 'Neither agree or disagree',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Agree a little',
    :value => 0,
    :description => 'Agree a little',
    :display_order => 4)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Agree strongly',
    :value => 0,
    :description => 'Agree strongly',
    :display_order => 5)
    
#   Existing/Proposed
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Not answered yet',
    :value => 0,
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Proposed',
    :value => 0,
    :description => 'Proposed',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Existing',
    :value => 0,
    :description => 'Existing',
    :display_order => 2)
    
#   Amount of impact
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Not answered yet',
    :value => 0,
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'None',
    :value => 0,
    :description => 'None',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Small minority',
    :value => 0,
    :description => 'Small minority',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Significant minority',
    :value => 0,
    :description => 'Significant minority',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'About half',
    :value => 0,
    :description => 'About half',
    :display_order => 4)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Majority',
    :value => 0,
    :description => 'Majority',
    :display_order => 5)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Substantial majority',
    :value => 0,
    :description => 'Substantial majority',
    :display_order => 6)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'All',
    :value => 0,
    :description => 'All',
    :display_order => 7)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Not sure',
    :value => 0,
    :description => 'Not sure',
    :display_order => 8)
    
    # Level of impact
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Not answered yet',
    :value => 0,
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'None',
    :value => 0,
    :description => 'None at all',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Limited',
    :value => 0,
    :description => 'Some impact',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Significant',
    :value => 0,
    :description => 'Significant impact',
    :display_order => 3)

    # Level of priority
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'Not answered yet',
    :value => 0,
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'Yes',
    :value => 0,
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'No',
    :value => 0,
    :description => 'No',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'Not sure',
    :value => 0,
    :description => 'Not sure',
    :display_order => 3)    
  end

  def self.down
    drop_table :look_ups
  end
end
