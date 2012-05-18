class AddingExtraAdditionalWorkQuestions < ActiveRecord::Migration
  def self.up
    Activity.all.each do |a|
      a.strands(true).each do |s|
        q = a.questions.create!( 
          :name => "additional_work_#{s}_10",
          :completed => false,
          :needed => false, 
          :raw_answer => "",
          :input_type => "text",
          :section => "additional_work", 
          :strand => s, 
          :raw_label => "Please explain what work needs to be done."
        )
        parent = a.questions.where(:name => "additional_work_#{s}_4").first
        parent.dependencies.create!(:child_question => q, :required_value => 1)
        next if s == "gender"
        q = a.questions.create!( 
            :name => "additional_work_#{s}_11",
            :completed => false,
            :needed => false, 
            :raw_answer => "",
            :input_type => "text",
            :section => "additional_work", 
            :strand => s, 
            :raw_label => "Please explain what work needs to be done."
          )
          parent = a.questions.where(:name => "additional_work_#{s}_6").first
          parent.dependencies.create!(:child_question => q, :required_value => 1)
      end
    end
  end

  def self.down
  end
end
