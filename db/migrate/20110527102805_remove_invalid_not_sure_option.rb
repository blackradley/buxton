class RemoveInvalidNotSureOption < ActiveRecord::Migration
  def self.up
    Question.all.each do |question|
      if question.help_text.match(/Not Sure/i) && !question.choices.blank? && !question.choices.include?("Not Sure")
        question.update_attribute(:help_text, question.help_text.gsub(/<li>Not Sure.*?<\/li>/, ''))
      end
    end
  end

  def self.down
  end
end
