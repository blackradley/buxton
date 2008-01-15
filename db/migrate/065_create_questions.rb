class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :activity_id
      t.string :name
      t.boolean :completed, :default => false
    end
  end

  def self.down
    drop_table :questions
  end
end
