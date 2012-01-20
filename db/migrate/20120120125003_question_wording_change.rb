class QuestionWordingChange < ActiveRecord::Migration
  
  def self.up
  	Question.all.each do |question|
  		question.raw_label = question.raw_label.gsub('EA', '#{function_policy_substitution}') if question.raw_label
  		question.raw_help_text = question.raw_help_text.gsub('EA', '#{function_policy_substitution}') if question.raw_help_text
  		question.save
  	end
  end

end
