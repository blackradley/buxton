class AlteringPolicyQuestion < ActiveRecord::Migration
  def self.up
    Question.where(:name => "purpose_overall_2").update_all(:raw_label => 'What is the purpose of this #{function_policy_substitution} and expected outcomes?')
    Question.where(:name => "additional_work_faith_6").update_all(:raw_label => 'Do you think that the #{function_policy_substitution} could assist Individuals of different religions or beliefs to get on better with each other - as well as those who do not have a religion or belief?')
  end

  def self.down
    Question.where(:name => "purpose_overall_2").update_all(:raw_label => 'What is the #{function_policy_substitution} supposed to achieve?')
    Question.where(:name => "additional_work_faith_6").update_all(:raw_label => 'Do you think that the #{function_policy_substitution} could assist Individuals of different religions or beliefs to get on better with each other - as well as those who do not have a religion or faith?')
  end
end
