class UpdateRelevanceTest < ActiveRecord::Migration
  def change
    Activity.strands.each do |strand|
      Activity.all.each do |act|
        qn = act.questions.find_by(name: "purpose_#{strand}_3")
        act.questions.create(name: "purpose_#{strand}_4",
                             completed: qn.completed,
                             needed: true,
                             raw_answer: qn.raw_answer,
                             choices: ["Not answered Yet", "Yes", "No"],
                             input_type: 'select',
                             section: 'purpose',
                             strand: strand,
                             raw_label: 'Is a full Equality Analysis required at this stage?',
                             raw_help_text: '')
      end
    end
  end
end
