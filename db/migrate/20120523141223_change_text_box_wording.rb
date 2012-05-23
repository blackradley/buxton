class ChangeTextBoxWording < ActiveRecord::Migration
  def self.up
    Question.all.select{|x| x.name == "additional_work_#{x.strand}_10" }.each do |question|
      question.update_attribute( :raw_label, 'Please explain how individuals may be impacted.' )
    end
    Question.all.select{|x| x.name == "additional_work_#{x.strand}_11" }.each do |question|
      question.update_attribute( :raw_label, 'Please explain how.' )
    end
  end

  def self.down
  end
end
