#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserve 
#
class MakingConsultationLookupWeights < ActiveRecord::Migration
  def self.up
	  
    $NO_ANSWER = 'Not answered yet'
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:consult_groups] ]
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:consult_experts] ] 
    
    
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'No relevant groups',
    :value => 1,
    :weight => 3,
    :description => 'No relevant groups',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'Plans to consult',
    :value => 2,
    :weight => 0,
    :description => 'Plans to consult',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'No plans to consult',
    :value => 3,
    :weight => 0,
    :description => 'No plans to consult',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'Not sure',
    :value => 4,
    :weight => 0,
    :description => 'Not sure',
    :display_order => 4) 
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'Not applicable',
    :value => 5,
    :weight => 0,
    :description => 'Not applicable',
    :display_order => 5)        

    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'No relevant experts',
    :value => 1,
    :weight => -2,
    :description => 'No relevant experts',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'Plans to consult',
    :value => 2,
    :weight => 0,
    :description => 'Plans to consult',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'No plans to consult',
    :value => 3,
    :weight => 0,
    :description => 'No plans to consult',
    :display_order => 3)    
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'Not sure',
    :value => 4,
    :weight => 0,
    :description => 'Not sure',
    :display_order => 4)    
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'Not applicable',
    :value => 5,
    :weight => 0,
    :description => 'Not applicable',
    :display_order => 5)    
  end

  def self.down
    $NO_ANSWER = 'Not answered yet'	  
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:consult_groups] ]
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:consult_experts] ] 
    
        LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'No relevant groups',
    :value => 1,
    :weight => 0,
    :description => 'No relevant groups',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'Plans to consult',
    :value => 2,
    :weight => 0,
    :description => 'Plans to consult',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'No plans to consult',
    :value => 3,
    :weight => 0,
    :description => 'No plans to consult',
    :display_order => 3)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'Not sure',
    :value => 4,
    :weight => 0,
    :description => 'Not sure',
    :display_order => 4) 
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_groups],
    :name => 'Not applicable',
    :value => 5,
    :weight => 0,
    :description => 'Not applicable',
    :display_order => 5)        

    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'No relevant experts',
    :value => 1,
    :weight => 0,
    :description => 'No relevant experts',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'Plans to consult',
    :value => 2,
    :weight => 0,
    :description => 'Plans to consult',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'No plans to consult',
    :value => 3,
    :weight => 0,
    :description => 'No plans to consult',
    :display_order => 3)    
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'Not sure',
    :value => 4,
    :weight => 0,
    :description => 'Not sure',
    :display_order => 4)    
    LookUp.create(:look_up_type => LookUp::TYPE[:consult_experts],
    :name => 'Not applicable',
    :value => 5,
    :weight => 0,
    :description => 'Not applicable',
    :display_order => 5)    
  end
end
