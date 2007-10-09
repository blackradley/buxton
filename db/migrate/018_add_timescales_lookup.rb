class AddTimescalesLookup < ActiveRecord::Migration
  def self.up
    $NO_ANSWER = 'Not answered yet'

    # Rating
    LookUp.create(:look_up_type => LookUp::TYPE[:timescales],
    :name => $NO_ANSWER,
    :value => 0,
    :weight => 0,
    :description => $NO_ANSWER,
    :display_order => 0)
    LookUp.create(:look_up_type => LookUp::TYPE[:timescales],
    :name => 'Less than six months',
    :value => 1,
    :weight => 0,
    :description => 'Less than six months',
    :display_order => 1)
    LookUp.create(:look_up_type => LookUp::TYPE[:timescales],
    :name => 'Six months to a year',
    :value => 2,
    :weight => 0,
    :description => 'Six months to a year',
    :display_order => 2)
    LookUp.create(:look_up_type => LookUp::TYPE[:timescales],
    :name => 'Over a year',
    :value => 3,
    :weight => 0,
    :description => 'Over a year',
    :display_order => 3)
  end

  def self.down
    LookUp.destroy_all [ "look_up_type = ?", LookUp::TYPE[:timescales] ]
  end
end
