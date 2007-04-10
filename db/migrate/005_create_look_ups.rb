class CreateLookUps < ActiveRecord::Migration
  def self.up
    create_table :look_ups, :force => true do |t|
      t.column :look_up_type,    :integer
      t.column :name,            :string
      t.column :description,     :string
      t.column :display_order,   :integer
    end
    
    # Yes/No/Not sure
    LookUp.create(:look_up_type => 1,
    :name => 'Yes',
    :description => 'Yes',
    :display_order => 1)

    LookUp.create(:look_up_type => 1,
    :name => 'Not sure',
    :description => 'Not sure',
    :display_order => 2)

    LookUp.create(:look_up_type => 1,
    :name => 'No',
    :description => 'No',
    :display_order => 3)

    # Agree/Disagree
    LookUp.create(:look_up_type => 2,
    :name => 'Disagree strongly',
    :description => 'Disagree strongly',
    :display_order => 1)
    
    LookUp.create(:look_up_type => 2,
    :name => 'Disagree a little',
    :description => 'Disagree a little',
    :display_order => 2)
    
    LookUp.create(:look_up_type => 2,
    :name => 'Neither agree or disagree',
    :description => 'Neither agree or disagree',
    :display_order => 3)
    
    LookUp.create(:look_up_type => 2,
    :name => 'Agree a little',
    :description => 'Agree a little',
    :display_order => 4)
    
    LookUp.create(:look_up_type => 2,
    :name => 'Agree strongly',
    :description => 'Agree strongly',
    :display_order => 5)
    
  end

  def self.down
    drop_table :look_ups
  end
end
