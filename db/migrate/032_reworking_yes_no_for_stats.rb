#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class ReworkingYesNoForStats < ActiveRecord::Migration
  def self.up
    $NO_ANSWER = 'Not answered yet'  
    #Adding all the new lookups
    
    #yes/no/notsure = 10/0/10
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_10_0],
	    :name => $NO_ANSWER,
	    :value => 0,
	    :weight => 0,
	    :description => $NO_ANSWER,
	    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_10_0],
	:name => 'Yes',
	:value => 1,
	:weight => 10,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_10_0],
	:name => 'No',
	:value => 2,
	:weight => 0,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_10_0],
	:name => 'Not sure',
	:value => 3,
	:weight => 10,
	:description => 'Not sure',
	:display_order => 3) 

    #Yes/no/notsure = -5/0/0
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n5_0],
	:name => $NO_ANSWER,
	:value => 0,
	:weight => 0,
	:description => $NO_ANSWER,
	:display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n5_0],
	:name => 'Yes',
	:value => 1,
	:weight => -5,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n5_0],
	:name => 'No',
	:value => 2,
	:weight => 0,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n5_0],
	:name => 'Not sure',
	:value => 3,
	:weight => 0,
	:description => 'Not sure',
	:display_order => 3) 
    
    #yes/no/notsure = -3/0/0
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n3_0],
	:name => $NO_ANSWER,
	:value => 0,
	:weight => 0,
	:description => $NO_ANSWER,
	:display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n3_0],
	:name => 'Yes',
	:value => 1,
	:weight => -3,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n3_0],
	:name => 'No',
	:value => 2,
	:weight => 0,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_n3_0],
	:name => 'Not sure',
	:value => 3,
	:weight => 0,
	:description => 'Not sure',
	:display_order => 3)

    #yes/no/notsure = 3/10/10
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_10],
	:name => $NO_ANSWER,
	:value => 0,
	:weight => 0,
	:description => $NO_ANSWER,
	:display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_10],
	:name => 'Yes',
	:value => 1,
	:weight => 3,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_10],
	:name => 'No',
	:value => 2,
	:weight => 10,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_10],
	:name => 'Not sure',
	:value => 3,
	:weight => 10,
	:description => 'Not sure',
	:display_order => 3) 

    #yes/no/notsure = 2/5/5
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_2_5],
	:name => $NO_ANSWER,
	:value => 0,
	:weight => 0,
	:description => $NO_ANSWER,
	:display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_2_5],
	:name => 'Yes',
	:value => 1,
	:weight => 2,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_2_5],
	:name => 'No',
	:value => 2,
	:weight => 5,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_2_5],
	:name => 'Not sure',
	:value => 3,
	:weight => 5,
	:description => 'Not sure',
	:display_order => 3)

    #yes/no/notsure = 15/0/15
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_15_0],
	:name => $NO_ANSWER,
	:value => 0,
	:weight => 0,
	:description => $NO_ANSWER,
	:display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_15_0],
	:name => 'Yes',
	:value => 1,
	:weight => 15,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_15_0],
	:name => 'No',
	:value => 2,
	:weight => 0,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_15_0],
	:name => 'Not sure',
	:value => 3,
	:weight => 15,
	:description => 'Not sure',
	:display_order => 3)

    #yes/no/notsure = 3/0/3
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_0],
	:name => $NO_ANSWER,
	:value => 0,
	:weight => 0,
	:description => $NO_ANSWER,
	:display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_0],
	:name => 'Yes',
	:value => 1,
	:weight => 3,
	:description => 'Yes',
	:display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_0],
	:name => 'No',
	:value => 2,
	:weight => 0,
	:description => 'No',
	:display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure_3_0],
	:name => 'Not sure',
	:value => 3,
	:weight => 3,
	:description => 'Not sure',
	:display_order => 3)   
  end

  def self.down
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_10_0] ]
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_n5_0] ]
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_n3_0] ]
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_3_10] ]
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_2_5] ]
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_15_0] ]
	LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure_3_0] ]
  end
end
