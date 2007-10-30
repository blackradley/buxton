#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class ChangeYesNoNotsureScores < ActiveRecord::Migration
  def self.up
    $NO_ANSWER = 'Not answered yet'
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure] ]	  
    # Yes/No/Not sure
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => 'Yes',
    :value => 1,
    :weight => 0,
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => 'No',
    :value => 2,
    :weight => 0,
    :description => 'No',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => 'Not sure',
    :value => 3,
    :weight => 0,
    :description => 'Not sure',
    :display_order => 3)  	  
  end

  def self.down
	      $NO_ANSWER = 'Not answered yet'
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure] ]
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => 'Yes',
    :value => 1,
    :weight => 10,
    :description => 'Yes',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => 'No',
    :value => 2,
    :weight => 0,
    :description => 'No',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:yes_no_notsure],
    :name => 'Not sure',
    :value => 3,
    :weight => 0,
    :description => 'Not sure',
    :display_order => 3)  
  end
end
