#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class AddingImpactHelpText < ActiveRecord::Migration
  def self.up
    wordings = {:gender => 'men and women',
      :race => 'individuals from different ethnic backgrounds',
      :disability => 'individuals with different kinds of disability',
      :faith => 'individuals of different faiths',
      :sexual_orientation => 'individuals of different sexual orientations',
      :age => 'individuals of different ages'}
      descriptive_term = {'gender' => 'gender',
      'race' => 'ethnicity',
      'disability' => 'disability',
      'faith' => 'faith',
      'sexual_orientation' => 'sexuality',
      'age' =>  'age'}

    #impact_strand_1 help text
    Activity.strands.each do |strand|
      add_seed :help_text, :question_name => "impact_#{strand}_1" do
        add_value :existing_function => "This question asks you to assess the current impact of the Function in meeting the particular needs of #{wordings[strand]}.<br/><br/>
             The available answers are on a five point scale from 5 excellent to 1 poor and as usual ‘Not sure’ is also an acceptable answer.<br/><br/>
             If the Function is not meeting the needs of any #{wordings[strand]} purely because of their #{descriptive_term[strand]} then clearly the impact of the Function in this
             regard is not positive."
        add_value :proposed_function => "This question asks you to assess the current impact of the Proposed Function in meeting the particular needs of #{wordings[strand]}.
            <br/><br/>  The available answers are on a five point scale from 5 excellent to 1 poor and as usual ‘Not sure’ is also an acceptable answer.<br/><br/>
             If the proposed function is not meeting the needs of any #{wordings[strand]} purely because of their #{descriptive_term[strand]} then clearly the impact of the
             proposed function in this regard is not positive."
        add_value :existing_policy => "This question asks you to assess the current impact of the policy in meeting the particular needs of #{wordings[strand]}.<br/><br/>
             The available answers are on a five point scale from 5 excellent to 1 poor and as usual ‘Not sure’ is also an acceptable answer.<br/><br/>
             If the policy is not meeting the needs of any #{wordings[strand]} purely because of their #{descriptive_term[strand]} then clearly the impact of the policy in this
             regard is not positive."
        add_value :proposed_policy => "This question asks you to assess the current impact of the proposed policy in meeting the particular needs of #{wordings[strand]}.<br/><br/>
             The available answers are on a five point scale from 5 excellent to 1 poor and as usual ‘Not sure’ is also an acceptable answer.<br/><br/>
             If the proposed policy is not meeting the needs of any #{wordings[strand]} purely because of their #{descriptive_term[strand]} then clearly the impact of the proposed
             policy in this regard is not positive."
      end

      #impact_strand_2 help text
      add_seed :help_text, :question_name => "impact_#{strand}_2" do
        add_value :existing_function => "This question asks you whether you have any information to support your assessment of the impact of the Function that you recorded in the
             previous question.<br/><br/>  The information could take a wide variety of forms from regular performance management information, evaluation work, surveys, academic
             publications and audit reports.<br/><br/>  The available answers are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul> If you have not got information to
             support the assessment of impact you might like to think on what basis you made the assessment."
        add_value :proposed_function => "This question asks you whether you have any information to support your assessment of the impact of the Function that you recorded in the
             previous question.<br/><br/>  The information could take a wide variety of forms from regular performance management information, evaluation work, surveys, academic
             publications and audit reports.<br/><br/>  The available answers are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul> If you have not got information to
             support the assessment of impact you might like to think on what basis you made the assessment."
        add_value :existing_policy =>  "This question asks you whether you have any information to support your assessment of the impact of the Policy that you recorded in the
             previous question.<br/><br/>  The information could take a wide variety of forms from regular performance management information, evaluation work, surveys, academic
             publications and audit reports.<br/><br/>  The available answers are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul> If you have not got information to
             support the assessment of impact you might like to think on what basis you made the assessment."
        add_value :proposed_policy => "This question asks you whether you have any information to support your assessment of the impact of the Policy that you recorded in the
             previous question.<br/><br/>  The information could take a wide variety of forms from regular performance management information, evaluation work, surveys, academic
             publications and audit reports.<br/><br/>  The available answers are:<br/> <ul><li>Yes</li> <li>No</li> <li>Not Sure</li> </ul> If you have not got information to
             support the assessment of impact you might like to think on what basis you made the assessment."
      end
      
      #impact_strand_3 help text
      add_seed :help_text, :question_name => "impact_#{strand}_3" do
        add_value :existing_function => "This question asks you to record the nature of the information you have used to make your assessment of the impact.<br/><br/>
             A brief description of the information, its source and date is sufficient. e.g.<br/> Internal Audit Report.<br/> ABC Ltd<br/>  October 2007."
        add_value :proposed_function => "This question asks you to record the nature of the information you have used to make your assessment of the impact.<br/><br/>
             A brief description of the information, its source and date is sufficient. e.g.<br/> Internal Audit Report.<br/> ABC Ltd<br/>  October 2007."
        add_value :existing_policy =>  "This question asks you to record the nature of the information you have used to make your assessment of the impact.<br/><br/>
             A brief description of the information, its source and date is sufficient. e.g.<br/> Internal Audit Report.<br/> ABC Ltd<br/>  October 2007."
        add_value :proposed_policy => "This question asks you to record the nature of the information you have used to make your assessment of the impact.<br/><br/>
             A brief description of the information, its source and date is sufficient. e.g.<br/> Internal Audit Report.<br/> ABC Ltd<br/>  October 2007."
      end
      
      #impact_strand_4 help text
      add_seed :help_text, :question_name => "impact_#{strand}_4" do
        add_value :existing_function => "This question asks you whether the Council has any plans to collect information to assess the impact of the Function."
        add_value :proposed_function => ""
        add_value :existing_policy =>  "This question asks you whether the Council has any plans to collect information to assess the impact of the Function."
        add_value :proposed_policy => ""
      end
      
      #impact_strand_5 help text
      add_seed :help_text, :question_name => "impact_#{strand}_5" do
        add_value :existing_function => "This question asks you to estimate the timescales for collecting additional information.<br/><br/>
             If you are not sure about the timescales please note this in the space provided."
        add_value :proposed_function => ""
        add_value :existing_policy =>  "This question asks you to estimate the timescales for collecting additional information.<br/><br/>
             If you are not sure about the timescales please note this in the space provided."
        add_value :proposed_policy => ""
      end
      
      #defining a couple of custom phrases needed
      impact_para = {'disability' => 'It is important to have regards for all types of disability including physical, sensory, learning and mental health.  <br/><br/>',
      'faith' => 'It is important to have regard for all faiths including both the major faiths such as Islam, Judaism and Christianity and
       any minority faiths. <br/><br/>'}
      
      #impact_strand_6 help text
      add_seed :help_text, :question_name => "impact_#{strand}_6" do
        add_value :existing_function => "This question asks you if there are other measures by which you could assess the impact of the Function on #{wordings[strand]}
             #{', including lesbian, gay, bisexual and transgender' if strand.to_s == 'sexual_orientation'}.  Such measures
             might be the level of complaints, anecdotal evidence or your first hand experience of the Function.<br/><br/>#{impact_para[strand.to_s]}
             The available answers to this question are:<br/>
             <ul><li>Yes</li>
             <li>No</li>
             <li>Not Sure</li>
             </ul><br/>
             In the light of this question you may want to go back and review your assessment of the impact of the Function on #{wordings[strand]}."
        add_value :proposed_function => ""
        add_value :existing_policy =>  "This question asks you if there are other measures by which you could assess the impact of the Policy on #{wordings[strand]}
             #{', including lesbian, gay, bisexual and transgender' if strand.to_s == 'sexual_orientation'}.  Such measures
             might be the level of complaints, anecdotal evidence or your first hand experience of the Policy.<br/><br/>#{impact_para[strand.to_s]}
             The available answers to this question are:<br/>
             <ul><li>Yes</li>
             <li>No</li>
             <li>Not Sure</li>
             </ul><br/>
             In the light of this question you may want to go back and review your assessment of the impact of the Function on #{wordings[strand]}."
        add_value :proposed_policy => ""
      end      
      
      #impact_strand_7 help text
      add_seed :help_text, :question_name => "impact_#{strand}_7" do
        add_value :existing_function => "This question asks you to record the details of any additional measures.<br/><br/>
             A brief description, source and date will be sufficient."
        add_value :proposed_function => ""
        add_value :existing_policy =>  "This question asks you to record the details of any additional measures.<br/><br/>
             A brief description, source and date will be sufficient."
        add_value :proposed_policy => ""
      end
      
      #impact_strand_8 help text
      add_seed :help_text, :question_name => "impact_#{strand}_8" do
        add_value :existing_function => "This question asks you whether all the information from the range of sources gives a consistent assessment of the impact of the Function."
        add_value :proposed_function => "This question asks you whether all the information from the range of sources gives a consistent assessment of the potential impact of
            the Function."
        add_value :existing_policy =>  "This question asks you whether all the information from the range of sources gives a consistent assessment of the impact of the Policy."
        add_value :proposed_policy => "This question asks you whether all the information from the range of sources gives a consistent assessment of the potential impact of
            the proposed Policy."
      end
      
      
      impact_9_examples = {:gender => 'This means that the impact on one particular group of individuals, men or women, is different than for the other group.',
        :race => 'This means that the impact on one particular group of individuals, say Polish people, is different than for another group.',
        :disability => 'This means that the impact on one particular group of individuals, say people with mental health conditions, is different than for another group.',
        :age => 'This means that the impact on one particular group of individuals, say elderly people, is different than for another group.',
        :faith => 'This means that the impact on one particular group of individuals, say people from the Sikh religion, is different than for another group.  ',
        :sexual_orientation => 'This means that the impact on one particular group of individuals, say bisexuals, is different than for another group.'}
        
      #impact_strand_9 help text
      add_seed :help_text, :question_name => "impact_#{strand}_9" do
        add_value :existing_function => "This question asks you to identify any issues about the way in which the Function has an impact upon people from different faiths.  An issue will be where there is a differential impact.  #{impact_9_examples[strand.to_sym]}<br/><br/>
             Differential impact can be positive or negative. Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
             Some differential impact is intentional and can be characterised as positive action."
        add_value :proposed_function => "This question asks you to identify any issues about the way in which the Function has an impact upon people from different faiths.  An issue will be where there is a differential impact.  #{impact_9_examples[strand.to_sym]}<br/><br/>
             Differential impact can be positive or negative. Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
             Some differential impact is intentional and can be characterised as positive action."
        add_value :existing_policy =>  "This question asks you to identify any issues about the way in which the Policy has an impact upon people from different faiths.  An issue will be where there is a differential impact.  #{impact_9_examples[strand.to_sym]}<br/><br/>
             Differential impact can be positive or negative. Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
             Some differential impact is intentional and can be characterised as positive action."
        add_value :proposed_policy => "This question asks you to identify any issues about the way in which the Policy has an impact upon people from different faiths.  An issue will be where there is a differential impact.  #{impact_9_examples[strand.to_sym]}<br/><br/>
             Differential impact can be positive or negative. Negative or adverse differential impact needs to be addressed by putting in place compensatory measures.<br/><br/>
             Some differential impact is intentional and can be characterised as positive action."
      end              
    end
  end

  def self.down
    Activity.strands.each do |strand|
      remove_seed :help_text, :question_name => "impact_#{strand}_1"
      remove_seed :help_text, :question_name => "impact_#{strand}_2"
      remove_seed :help_text, :question_name => "impact_#{strand}_3"
      remove_seed :help_text, :question_name => "impact_#{strand}_4"
      remove_seed :help_text, :question_name => "impact_#{strand}_5"
      remove_seed :help_text, :question_name => "impact_#{strand}_6"
      remove_seed :help_text, :question_name => "impact_#{strand}_7"
      remove_seed :help_text, :question_name => "impact_#{strand}_8"
      remove_seed :help_text, :question_name => "impact_#{strand}_9"
    end
  end
end
