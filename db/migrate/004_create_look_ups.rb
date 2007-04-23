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
    LookUp.create(:look_up_type => LookUp::YES_NO,
    :name => 'Yes',
    :description => 'Yes',
    :display_order => 0)

    LookUp.create(:look_up_type => LookUp::YES_NO,
    :name => 'No',
    :description => 'No',
    :display_order => 1)
    
    LookUp.create(:look_up_type => LookUp::YES_NO,
    :name => 'Not sure',
    :description => 'Not sure',
    :display_order => 2)

    # Agree/Disagree
    LookUp.create(:look_up_type => LookUp::AGREE_DISAGREE,
    :name => 'Disagree strongly',
    :description => 'Disagree strongly',
    :display_order => 0)
    
    LookUp.create(:look_up_type => LookUp::AGREE_DISAGREE,
    :name => 'Disagree a little',
    :description => 'Disagree a little',
    :display_order => 1)
    
    LookUp.create(:look_up_type => LookUp::AGREE_DISAGREE,
    :name => 'Neither agree or disagree',
    :description => 'Neither agree or disagree',
    :display_order => 2)
    
    LookUp.create(:look_up_type => LookUp::AGREE_DISAGREE,
    :name => 'Agree a little',
    :description => 'Agree a little',
    :display_order => 3)
    
    LookUp.create(:look_up_type => LookUp::AGREE_DISAGREE,
    :name => 'Agree strongly',
    :description => 'Agree strongly',
    :display_order => 4)
    
    # Existing/Proposed
    LookUp.create(:look_up_type => LookUp::EXISTING_PROPOSED,
    :name => 'Proposed',
    :description => 'Proposed',
    :display_order => 0)
    
    LookUp.create(:look_up_type => LookUp::EXISTING_PROPOSED,
    :name => 'Existing',
    :description => 'Existing',
    :display_order => 1)
    
    # Existing/Proposed
    LookUp.create(:look_up_type => LookUp::PROPORTION,
    :name => 'None',
    :description => 'None at all, 0%',
    :display_order => 0)

    LookUp.create(:look_up_type => LookUp::PROPORTION,
    :name => 'A few',
    :description => 'Some, up to 20%',
    :display_order => 1)

    LookUp.create(:look_up_type => LookUp::PROPORTION,
    :name => 'Less than half',
    :description => 'Less than half, between 20% and 50%',
    :display_order => 2)

    LookUp.create(:look_up_type => LookUp::PROPORTION,
    :name => 'More than half',
    :description => 'More than half, between 50% and 80%',
    :display_order => 3)

    LookUp.create(:look_up_type => LookUp::PROPORTION,
    :name => 'Nearly all',
    :description => 'Nearly all, between 80% and 100%',
    :display_order => 4)

  end

  def self.down
    drop_table :look_ups
  end
end
