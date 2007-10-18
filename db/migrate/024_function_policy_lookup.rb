class FunctionPolicyLookup < ActiveRecord::Migration
  def self.up
    $NO_ANSWER = 'Not answered yet'
    # Function/Policy
    LookUp.create(:look_up_type => LookUp::TYPE[:function_policy],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:function_policy],
    :name => 'Function',
    :value => 1,
    :weight => 0,
    :description => 'Function',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:function_policy],
    :name => 'Policy',
    :value => 2,
    :weight => 0,
    :description => 'Policy',
    :display_order => 2)    
  end

  def self.down
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:function_policy] ]    
  end
end
