#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class HelpTextForConsultation < ActiveRecord::Migration
  def self.up
    wordings = {'gender' => 'men and women',
      'race' => 'individuals from different ethnic backgrounds',
      'disability' => 'individuals with different kinds of disability',
      'faith' => 'individuals of different faiths',
      'sexual_orientation' => 'individuals of different sexual orientations',
      'age' => 'individuals of different ages'}
      
      Activity.strands.each do |strand|
        #consultation_strand_1 help text
        question_1_extra_text = {:race => 'It will be important to ensure that the consultation includes people from a range of ethnic backgrounds.  <br/><br/>',
          :disability => 'It will be important to ensure that the consultation includes people with a range of disabilities, including physical, sensory, learning and
                         mental health.<br/><br/>',
          :faith => 'It will be important to ensure that the consultation includes people from a range of faiths, including both majority and minority religions. <br/><br/>',
          :sexual_orientation => 'It will be important to ensure that the consultation includes people from a range of sexual orientations , including lesbian, gay, bisexual
                                  and transgender. <br/><br/>'}
                                  
        add_seed :help_text, :question_name => "consultation_#{strand}_1" do
          add_value :existing_function => "This question asks whether any individuals representing the interests of #{wordings[strand]} have been consulted on the impact of the
               Function.<br/><br/> #{question_1_extra_text[strand.to_sym]} The consultation may have been arranged specifically for this particular Function
               or for a number of Functions.<br/><br/> The available answers to this question are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul><br/>"
          add_value :proposed_function => "This question asks whether any individuals representing the interests of #{wordings[strand]} have been consulted on the potential impact of
               the Function.<br/><br/> #{question_1_extra_text[strand.to_sym]} The consultation may have been arranged specifically for this particular Function
               or for a number of Functions.<br/><br/> The available answers to this question are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul><br/>"
          add_value :existing_policy =>  "This question asks whether any individuals representing the interests of #{wordings[strand]} have been consulted on the impact of the
               Function.<br/><br/> #{question_1_extra_text[strand.to_sym]} The consultation may have been arranged specifically for this particular Policy
               or for a number of Policies.<br/><br/> The available answers to this question are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul><br/>"
          add_value :proposed_policy => "This question asks whether any individuals representing the interests of #{wordings[strand]} have been consulted on the potential impact of
               the Policy.<br/><br/> #{question_1_extra_text[strand.to_sym]} The consultation may have been arranged specifically for this particular Function
               or for a number of Policies.<br/><br/> The available answers to this question are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul><br/>"
        end
        
        #consultation_strand_2 help text      
        add_seed :help_text, :question_name => "consultation_#{strand}_2" do
          add_value :existing_function => "This question asks why groups have not been consulted on the impact of the Function.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant individuals identified.  This would be the correct answer if it had been decided that there were no suitable groups representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant individuals.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant individuals.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
          add_value :proposed_function => "This question asks why groups have not been consulted on the impact of the Function.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant individuals identified.  This would be the correct answer if it had been decided that there were no suitable groups representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant individuals.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant individuals.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
          add_value :existing_policy =>  "This question asks why groups have not been consulted on the impact of the Policy.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant individuals identified.  This would be the correct answer if it had been decided that there were no suitable groups representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant individuals.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant individuals.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
          add_value :proposed_policy => "This question asks why groups have not been consulted on the impact of the Policy.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant individuals identified.  This would be the correct answer if it had been decided that there were no suitable groups representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant individuals.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant individuals.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
        end
        
        #consultation_strand_3 help text
        add_seed :help_text, :question_name => "consultation_#{strand}_3" do
          add_value :existing_function => "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
          add_value :proposed_function => "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
          add_value :existing_policy =>  "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
          add_value :proposed_policy => "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
        end
        
        #consultation_strand_4 help text
        add_seed :help_text, :question_name => "consultation_#{strand}_4" do
          add_value :existing_function => "This question asks whether any stakeholders with knowledge and expertise on the #{"different " if strand == "gender"}interests of #{wordings[strand]} have been consulted on the impact of the Function.<br/><br/>
               #{question_1_extra_text[strand.to_sym]}
               The consultation may have been arranged specifically for this particular Function or for a number of Functions.<br/><br/>
               The available answers to this question are:<br/>
               <ul><li>Yes</li>
               <li>No</li>
               <li>Not Sure</li>
               </ul><br/>"
          add_value :proposed_function => "This question asks whether any stakeholders with knowledge and expertise on the #{"different " if strand == "gender"}interests of #{wordings[strand]} have been consulted on the potential impact of the Function.<br/><br/>
               #{question_1_extra_text[strand.to_sym]}
               The consultation may have been arranged specifically for this particular Function or for a number of Functions.<br/><br/>
               The available answers to this question are:<br/>
               <ul><li>Yes</li>
               <li>No</li>
               <li>Not Sure</li>
               </ul><br/>"
          add_value :existing_policy =>  "This question asks whether any stakeholders with knowledge and expertise on the #{"different " if strand == "gender"}interests of #{wordings[strand]} have been consulted on the impact of the Policy.<br/><br/>
               #{question_1_extra_text[strand.to_sym]}
               The consultation may have been arranged specifically for this particular Policy or for a number of Policies.<br/><br/>
               The available answers to this question are:<br/>
               <ul><li>Yes</li>
               <li>No</li>
               <li>Not Sure</li>
               </ul><br/>"
          add_value :proposed_policy => "This question asks whether any stakeholders with knowledge and expertise on the #{"different " if strand == "gender"}interests of #{wordings[strand]} have been consulted on the potential impact of the Policy.<br/><br/>
               #{question_1_extra_text[strand.to_sym]}
               The consultation may have been arranged specifically for this particular Policy or for a number of Policies.<br/><br/>
               The available answers to this question are:<br/>
               <ul><li>Yes</li>
               <li>No</li>
               <li>Not Sure</li>
               </ul><br/>"
        end
        
        #consultation_strand_5 help text
        add_seed :help_text, :question_name => "consultation_#{strand}_5" do
          add_value :existing_function => "This question asks why stakeholders have not been consulted on the impact of the Function.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant stakeholders identified.  This would be the correct answer if it had been decided that there were no suitable stakeholders representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant stakeholders.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant stakeholders.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
          add_value :proposed_function => "This question asks why stakeholders have not been consulted on the impact of the Function.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant stakeholders identified.  This would be the correct answer if it had been decided that there were no suitable stakeholders representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant stakeholders.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant stakeholders.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
          add_value :existing_policy =>  "This question asks why stakeholders have not been consulted on the impact of the Policy.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant stakeholders identified.  This would be the correct answer if it had been decided that there were no suitable stakeholders representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant stakeholders.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant stakeholders.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
          add_value :proposed_policy => "This question asks why stakeholders have not been consulted on the impact of the Policy.<br/><br/>
               The available answers to this question are:<ul>
               <li>No relevant stakeholders identified.  This would be the correct answer if it had been decided that there were no suitable stakeholders representing the interests of #{wordings[strand]} to consult with.</li>
               <li>There are plans to consult relevant stakeholders.  This would be the correct answer if the consultation was planned but had not yet taken place.</li>
               <li>There are no plans to consult relevant stakeholders.  There may be reasons why the Council had decided not to consult on the impact of the Function.</li>
               <li>Not Sure.  As always an acceptable answer if you are unsure.</li></ul>"
        end

        #consultation_strand_6 help text
        add_seed :help_text, :question_name => "consultation_#{strand}_6" do
          add_value :existing_function => "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
          add_value :proposed_function => "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
          add_value :existing_policy =>  "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
          add_value :proposed_policy => "This question asks you to list the groups that have been consulted and the date of the consultation.<br/><br/>
               If any future consultations are planned please record these details as well."
        end
        
        strand_examples = {'gender' => 'This means that the impact on one particular group of individuals, men or women, is different than for the other group.',
          'race' => 'This means that the impact on one particular group of individuals, say Polish people, is different than for another group.',
          'disability' => 'This means that the impact on one particular group of individuals, say people with mental health conditions, is different than for another group.',
          'age' => 'This means that the impact on one particular group of individuals, say elderly people, is different than for another group.',
          'faith' => 'This means that the impact on one particular group of individuals, say people from the Sikh religion, is different than for another group.  ',
          'sexual_orientation' => 'This means that the impact on one particular group of individuals, say bisexuals, is different than for another group.'}

        #consultation_strand_7 help text
        add_seed :help_text, :question_name => "consultation_#{strand}_7" do
          add_value :existing_function => "This question asks you to identify any issues about the way in which the Function has an impact upon people from different faiths.
               An issue will be where there is a differential impact.  #{strand_examples[strand].to_s}<br/><br/>
               Differential impact can be positive or negative.  Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
               Some differential impact is intentional and can be characterised as positive action."
          add_value :proposed_function => "This question asks you to identify any issues about the way in which the Function has an impact upon people from different faiths.
               An issue will be where there is a differential impact.  #{strand_examples[strand].to_s}<br/><br/>
               Differential impact can be positive or negative.  Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
               Some differential impact is intentional and can be characterised as positive action."
          add_value :existing_policy =>  "This question asks you to identify any issues about the way in which the Policy has an impact upon people from different faiths.
               An issue will be where there is a differential impact.  #{strand_examples[strand].to_s}<br/><br/>
               Differential impact can be positive or negative.  Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
               Some differential impact is intentional and can be characterised as positive action."
          add_value :proposed_policy => "This question asks you to identify any issues about the way in which the Policy has an impact upon people from different faiths.
               An issue will be where there is a differential impact.  #{strand_examples[strand].to_s}<br/><br/>
               Differential impact can be positive or negative.  Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
               Some differential impact is intentional and can be characterised as positive action."
        end      
    end
  end

  def self.down
    Activity.strands.each do |strand|
      remove_seed :help_text, :question_name => "consultation_#{strand}_1"
      remove_seed :help_text, :question_name => "consultation_#{strand}_2"
      remove_seed :help_text, :question_name => "consultation_#{strand}_3"
      remove_seed :help_text, :question_name => "consultation_#{strand}_4"
      remove_seed :help_text, :question_name => "consultation_#{strand}_5"
      remove_seed :help_text, :question_name => "consultation_#{strand}_6"
      remove_seed :help_text, :question_name => "consultation_#{strand}_7" 
    end
  end
end
