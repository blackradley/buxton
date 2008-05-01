class CreateTerminologies < ActiveRecord::Migration
  def self.up
    create_table :terminologies do |t|
      t.string :term, :default => ''
      t.timestamps
    end
  end

  def self.down
    drop_table :terminologies
  end
end
