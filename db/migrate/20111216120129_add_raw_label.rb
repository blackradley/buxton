class AddRawLabel < ActiveRecord::Migration
  def self.up
    add_column :questions, :raw_label, :text
    add_column :questions, :raw_help_text, :text
    Question.reset_column_information
    Question.all.each do |q| 
      q.update_attributes(:raw_label => q.label, :raw_help_text => q.help_text)
    end
    remove_column :questions, :help_text
    remove_column :questions, :label
  end

  def self.down
    add_column :questions, :label, :text
    add_column :questions, :raw_help_text, :text
    Question.reset_column_information
    Question.all.each do |q| 
      q.update_attributes(:label => q.raw_label, :help_text => q.raw_help_text)
    end
    remove_column :questions, :raw_label
    remove_column :questions, :raw_help_text
  end
end
