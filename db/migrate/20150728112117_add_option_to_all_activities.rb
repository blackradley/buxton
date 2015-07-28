class AddOptionToAllActivities < ActiveRecord::Migration
  def change
    Question.where(name: 'consultation_age_2').each{|q| q.update_attribute(:choices, q.choices << 'Consultation not required at this time')}
  end
end
