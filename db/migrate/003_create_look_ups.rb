class CreateLookUps < ActiveRecord::Migration
  def self.up
    create_table :look_ups do |t|
      t.column "look_up_type",    :integer,   :limit => 2,   :null => false
      t.column "name",            :string,    :limit => 128, :null => false
      t.column "description",     :string,    :limit => 256, :null => false
    end
  end

  def self.down
    drop_table :look_ups
  end
end
