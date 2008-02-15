class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :question_id
      t.text :contents
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
