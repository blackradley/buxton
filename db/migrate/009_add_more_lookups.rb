#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class AddMoreLookups < ActiveRecord::Migration
  def self.up
    $NO_ANSWER = 'Not answered yet'

    # Rating
    LookUp.create(:look_up_type => LookUp::TYPE[:rating],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:rating],
    :name => '5 - excellent',
    :value => 5,
    :weight => 10,
    :description => '5 - excellent',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:rating],
    :name => '4 - good',
    :value => 4,
    :weight => 15,
    :description => '4 - good',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:rating],
    :name => '3 - at expectations',
    :value => 3,
    :weight => 20,
    :description => '3 - at expectations',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:rating],
    :name => '2 - below expectations',
    :value => 2,
    :weight => 25,
    :description => '2 - below expectations',
    :display_order => 4)
    LookUp.create(:look_up_type => LookUp::TYPE[:rating],
    :name => '1 - poor',
    :value => 1,
    :weight => 30,
    :description => '1 - poor',
    :display_order => 5)

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

  def self.down
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:rating] ]
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:yes_no_notsure] ]
  end
end
