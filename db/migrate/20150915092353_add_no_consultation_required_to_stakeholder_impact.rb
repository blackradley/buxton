class AddNoConsultationRequiredToStakeholderImpact < ActiveRecord::Migration
  def change
    Activity.strands.each do |strand|
      Activity.all.each do |act|
        unless act.submitted
          act.questions.where(name: "consultation_#{strand}_5").each{|q| q.update_attribute(:choices, q.choices << 'Consultation not required at this time')}
        end
      end
    end
  end
end
