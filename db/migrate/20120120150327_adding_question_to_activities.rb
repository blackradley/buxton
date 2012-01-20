class AddingQuestionToActivities < ActiveRecord::Migration
  def self.up
  	Activity.all.each do |activity|
  		Activity.strands.each do |strand|
	  		question = Question.where(:activity_id => activity.id).find_by_name("additional_work_#{strand}_3")
	  		dependency = Dependency.new(:question_id => question.id, :required_value => 1)
	  		dependency.save
	  		need = question.raw_answer == '1' ? true : false
	  		new_question = activity.questions.new(:name => "additional_work_#{strand}_44", :completed => false, :needed => need, :input_type => 'text', :section => 'additional_work', :strand => strand, :dependency_id => dependency.id, :raw_label => "Please explain what work needs to be done.", :raw_help_text => 'A brief description of the nature of the work and timescales for completion will be sufficient.')
	  		new_question.save
	  		dependency.child_question_id = new_question.id
	  		dependency.save
	  	end
  	end
  end
end
