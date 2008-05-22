#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class HelpTextForAdditionalWork < ActiveRecord::Migration
  def self.up
    wordings = {'gender' => 'men and women',
      'race' => 'individuals from different ethnic backgrounds',
      'disability' => 'individuals with different kinds of disability',
      'faith' => 'individuals of different faiths',
      'sexual_orientation' => 'individuals of different sexual orientations',
      'age' => 'individuals of different ages'}
      
      descriptive_term = {'gender' => 'gender',
      'race' => 'ethnicity',
      'disability' => 'disability',
      'faith' => 'faith',
      'sexual_orientation' => 'sexuality',
      'age' =>  'age'}
      
      Activity.strands.each do |strand|
        #additional_work_strand_1 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_1" do
          add_value :existing_function => "This question asks you to reflect upon whether you think that you need further information to obtain a comprehensive view of the impact of the Function.<br/><br/>
             The Impact section asked you to identify existing information to assess the impact of the function on #{wordings[strand]}.<br/><br/>
             The Consultation section asked you to who had been consulted about the impact of the Function. <br/><br/>
             Even with these two sources of information you may feel that there is additional information required such as further data collection and analysis of further consultation."
          add_value :proposed_function => "This question asks you to reflect upon whether you think that you need further information to obtain a comprehensive view of the potential impact of the Function.<br/><br/>
             The Impact section asked you to identify existing information to assess the potential impact of the function on #{wordings[strand]}.<br/><br/>
             The Consultation section asked you to who had been consulted about the potential impact of the Function. <br/><br/>
             Even with these two sources of information you may feel that there is additional information required such as further data collection and analysis of further consultation."
          add_value :existing_policy =>  "This question asks you to reflect upon whether you think that you need further information to obtain a comprehensive view of the impact of the Policy.<br/><br/>
             The Impact section asked you to identify existing information to assess the impact of the function on #{wordings[strand]}.<br/><br/>
             The Consultation section asked you to who had been consulted about the impact of the Policy. <br/><br/>
             Even with these two sources of information you may feel that there is additional information required such as further data collection and analysis of further consultation."
          add_value :proposed_policy => "This question asks you to reflect upon whether you think that you need further information to obtain a comprehensive view of the potential impact of the Policy.<br/><br/>
             The Impact section asked you to identify existing information to assess the potential impact of the function on #{wordings[strand]}.<br/><br/>
             The Consultation section asked you to who had been consulted about the potential impact of the Policy. <br/><br/>
             Even with these two sources of information you may feel that there is additional information required such as further data collection and analysis of further consultation."
        end
        
        #additional_work_strand_2 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_2" do
          add_value :existing_function => "A brief description of the nature of the information, source and timescales for collection will be sufficient."
          add_value :proposed_function => "A brief description of the nature of the information, source and timescales for collection will be sufficient."
          add_value :existing_policy =>  "A brief description of the nature of the information, source and timescales for collection will be sufficient."
          add_value :proposed_policy => "A brief description of the nature of the information, source and timescales for collection will be sufficient."
        end
        
        #additional_work_strand_3 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_3" do
          add_value :existing_function => ""
          add_value :proposed_function => ""
          add_value :existing_policy =>  ""
          add_value :proposed_policy => ""
        end
        
        #additional_work_strand_4 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_4" do
          add_value :existing_function => "This question asks you to assess whether the Function could have a role in eliminating discrimination or harassment faced by #{wordings[strand]} as a result of their #{descriptive_term[strand]}.<br/><br/>
             There will be a minority of Functions that are intended to eliminate discrimination or harassment as their primary purpose and some Functions which might have a secondary role in eliminating discrimination or harassment."
          add_value :proposed_function => "This question asks you to assess whether the Function could have a role in eliminating discrimination or harassment faced by #{wordings[strand]} as a result of their #{descriptive_term[strand]}.<br/><br/>
             There will be a minority of Functions that are intended to eliminate discrimination or harassment as their primary purpose and some Functions which might have a secondary role in eliminating discrimination or harassment."
          add_value :existing_policy =>  "This question asks you to assess whether the Policy could have a role in eliminating discrimination or harassment faced by #{wordings[strand]} as a result of their #{descriptive_term[strand]}.<br/><br/>
             There will be a minority of Policies that are intended to eliminate discrimination or harassment as their primary purpose and some Policies which might have a secondary role in eliminating discrimination or harassment."
          add_value :proposed_policy => "This question asks you to assess whether the Policy could have a role in eliminating discrimination or harassment faced by #{wordings[strand]} as a result of their #{descriptive_term[strand]}.<br/><br/>
             There will be a minority of Policies that are intended to eliminate discrimination or harassment as their primary purpose and some Policies which might have a secondary role in eliminating discrimination or harassment."
        end

        #additional_work_strand_5 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_5" do
          add_value :existing_function => "This question asks you to assess whether the Function could have a role in promoting equality of opportunity for #{wordings[strand]}.<br/><br/>
             There will be a minority of Functions that are intended to eliminate equality of opportunity as their primary purpose and some Functions which might have a secondary role in promoting equality"
          add_value :proposed_function => "This question asks you to assess whether the Function could have a role in promoting equality of opportunity for #{wordings[strand]}.<br/><br/>
             There will be a minority of Functions that are intended to eliminate equality of opportunity as their primary purpose and some Functions which might have a secondary role in promoting equality."
          add_value :existing_policy =>  "This question asks you to assess whether the Policy could have a role in promoting equality of opportunity for #{wordings[strand]}.<br/><br/>
             There will be a minority of Policies that are intended to eliminate equality of opportunity as their primary purpose and some Policies which might have a secondary role in promoting equality."
          add_value :proposed_policy => "This question asks you to assess whether the Policy could have a role in promoting equality of opportunity for #{wordings[strand]}.<br/><br/>
             There will be a minority of Policies that are intended to eliminate equality of opportunity as their primary purpose and some Policies which might have a secondary role in promoting equality."
        end        
        
        unless strand.to_s == 'gender' then
        #additional_work_strand_6 help text
          add_seed :help_text, :question_name => "additional_work_#{strand}_6" do
            add_value :existing_function => "This question asks you to assess whether the Function could have a role in assisting #{wordings[strand]} to get on better with each other.<br/><br/>
             There will be a minority of Functions that are intended to promote good relations as their primary purpose and some Functions that might have this as a secondary role."
            add_value :proposed_function => "This question asks you to assess whether the Function could have a role in assisting #{wordings[strand]} to get on better with each other.<br/><br/>
             There will be a minority of Functions that are intended to promote good relations as their primary purpose and some Functions that might have this as a secondary role."
            add_value :existing_policy =>  "This question asks you to assess whether the Policy could have a role in assisting #{wordings[strand]} to get on better with each other.<br/><br/>
             There will be a minority of Policies that are intended to promote good relations as their primary purpose and some Policies that might have this as a secondary role."
            add_value :proposed_policy => "This question asks you to assess whether the Policy could have a role in assisting #{wordings[strand]} to get on better with each other.<br/><br/>
             There will be a minority of Policies that are intended to promote good relations as their primary purpose and some Policies that might have this as a secondary role."
          end          
        
        end
        
       if strand.to_s == 'disability' then
          #additional_work_disability_7 help text
          add_seed :help_text, :question_name => "additional_work_#{strand}_7" do
            add_value :existing_function => "The question asks whether the Function takes account of disabilities even if it means treating people with disabilities more favourably.<br/><br/>
             As noted in the Impact section this type of intentional positive impact can be characterized as positive action."
            add_value :proposed_function => "The question asks whether the Function takes account of disabilities even if it means treating people with disabilities more favourably.<br/><br/>
             As noted in the Impact section this type of intentional positive impact can be characterized as positive action."
            add_value :existing_policy =>  "The question asks whether the Policy takes account of disabilities even if it means treating people with disabilities more favourably.<br/><br/>
             As noted in the Impact section this type of intentional positive impact can be characterized as positive action."
            add_value :proposed_policy => "The question asks whether the Policy takes account of disabilities even if it means treating people with disabilities more favourably.<br/><br/>
             As noted in the Impact section this type of intentional positive impact can be characterized as positive action."
          end
        
        #additional_work_disability_8 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_8" do
          add_value :existing_function => "The question asks you whether the Function could encourage individuals with different types of disability to participate more in society.<br/><br/>
             Functions which assisted with access, both physical and information, for people with different types of disability might assist in this regard."
          add_value :proposed_function => "The question asks you whether the Function could encourage individuals with different types of disability to participate more in society.<br/><br/>
             Functions which assisted with access, both physical and information, for people with different types of disability might assist in this regard."
          add_value :existing_policy => "The question asks you whether the Policy could encourage individuals with different types of disability to participate more in society.<br/><br/>
             Policies which assisted with access, both physical and information, for people with different types of disability might assist in this regard."
          add_value :proposed_policy => "The question asks you whether the Policy could encourage individuals with different types of disability to participate more in society.<br/><br/>
             Policies which assisted with access, both physical and information, for people with different types of disability might assist in this regard."
        end
        
        #additional_work_strand_9 help text
        add_seed :help_text, :question_name => "additional_work_#{strand}_9" do
          add_value :existing_function => "The question asks you whether the Function could assist in promoting positive attitudes to individuals with different types of disability."
          add_value :proposed_function => "The question asks you whether the Function could assist in promoting positive attitudes to individuals with different types of disability."
          add_value :existing_policy =>  "The question asks you whether the Policy could assist in promoting positive attitudes to individuals with different types of disability."
          add_value :proposed_policy => "The question asks you whether the Policy could assist in promoting positive attitudes to individuals with different types of disability."
        end        
       
       end
       
      end
  end

  def self.down
    Activity.strands.each do |strand|
      remove_seed :help_text, :question_name => "additional_work_#{strand}_1"
      remove_seed :help_text, :question_name => "additional_work_#{strand}_2"
      remove_seed :help_text, :question_name => "additional_work_#{strand}_3"
      remove_seed :help_text, :question_name => "additional_work_#{strand}_4"
      remove_seed :help_text, :question_name => "additional_work_#{strand}_5"
      remove_seed :help_text, :question_name => "additional_work_#{strand}_6" unless strand.to_s == 'gender'
      if strand.to_s == 'disability' then
        remove_seed :help_text, :question_name => "additional_work_#{strand}_7"
        remove_seed :help_text, :question_name => "additional_work_#{strand}_8"
        remove_seed :help_text, :question_name => "additional_work_#{strand}_9"
      end
    end  
  end
end
