class PutHelpTextBackIn < ActiveRecord::Migration
  def self.up
  	Activity.all.each do |activity|
  		activity.reset_question_texts(false)
  	end
  end
end
