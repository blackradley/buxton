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
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer
    end
    
    # Yes/No/Not sure
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Not answered yet',
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Yes',
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'No',
    :description => 'No',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no],
    :name => 'Not sure',
    :description => 'Not sure',
    :display_order => 3)

    # Agree/Disagree
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Not answered yet',
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Disagree strongly',
    :description => 'Disagree strongly',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Disagree a little',
    :description => 'Disagree a little',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Neither agree or disagree',
    :description => 'Neither agree or disagree',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Agree a little',
    :description => 'Agree a little',
    :display_order => 4)
    LookUp.create(:look_up_type => LookUp::TYPE[:agree_disagree],
    :name => 'Agree strongly',
    :description => 'Agree strongly',
    :display_order => 5)
    
#   Existing/Proposed
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Not answered yet',
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Proposed',
    :description => 'Proposed',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:existing_proposed],
    :name => 'Existing',
    :description => 'Existing',
    :display_order => 2)
    
#   Amount of impact
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Not answered yet',
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'None',
    :description => 'None',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Small minority',
    :description => 'Small minority',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Significant minority',
    :description => 'Significant minority',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'About half',
    :description => 'About half',
    :display_order => 4)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Majority',
    :description => 'Majority',
    :display_order => 5)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Substantial majority',
    :description => 'Substantial majority',
    :display_order => 6)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'All',
    :description => 'All',
    :display_order => 7)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_amount],
    :name => 'Not sure',
    :description => 'Not sure',
    :display_order => 8)
    
    # Level of impact
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Not answered yet',
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'None',
    :description => 'None at all',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Limited',
    :description => 'Some impact',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:impact_level],
    :name => 'Significant',
    :description => 'Significant impact',
    :display_order => 3)

    # Level of priority
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'Not answered yet',
    :description => 'Not answered yet',
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'Yes',
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'No',
    :description => 'No',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:priority],
    :name => 'Not sure',
    :description => 'Not sure',
    :display_order => 3)    
  end

  def self.down
    drop_table :look_ups
  end
end
