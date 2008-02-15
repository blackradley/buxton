class ReviewDate < ActiveRecord::Migration
  def self.up
    add_column :activities, :review_on, :date
  end

  def self.down
    remove_column :activities, :review_on
  end
end
