class UpdateAdditionalWorkQuestions < ActiveRecord::Migration
  def change
    Activity.strands.each do |strand|
      Activity.all.each do |act|
        unless act.submitted
          act.questions.find_by(name: "impact_#{strand}_9").try(:destroy)
          act.questions.find_by(name: "impact_#{strand}_6").try(:destroy)
          act.questions.find_by(name: "impact_#{strand}_7").try(:destroy)
          act.questions.find_by(name: "additional_work_#{strand}_3").try(:destroy)
          act.questions.find_by(name: "additional_work_#{strand}_44").try(:destroy)
          act.questions.find_by(name: "additional_work_#{strand}_1").update_attributes(raw_label: "Do you need any more information or to do any more work to complete the assessment?")
          act.questions.find_by(name: "additional_work_#{strand}_2").update_attributes(raw_label: "Please explain what information you need, or what work needs to be done.")
          act.questions.find_by(name: "consultation_#{strand}_7").update_attributes(raw_label: "Is a further action plan required?")
        end
      end
    end
  end
end
