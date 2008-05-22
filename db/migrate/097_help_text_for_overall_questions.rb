#  
# $URL$ 
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved. 
#
class HelpTextForOverallQuestions < ActiveRecord::Migration
  def self.up
    #purpose_overall_2 help text
    add_seed :help_text, :question_name => 'purpose_overall_2' do 
      add_value :existing_function => "This question asks you to identify the target outcome or desired state of affairs which the Function is designed to deliver.  If the Function does the job which it is supposed to do, what will it change or achieve.<br/><br/>
             Examples of target outcomes are:<ul> <li>A narrowing of the gap between the local employment rate for priority disadvantaged groups and the national rate.</li>
             <li>An improvement in the skill levels of the workforce to better meet the needs of the local economy.</li></ul> It is unlikely that the target outcome will be expressed in terms of numerical targets or outputs."
      add_value :proposed_function => "This question asks you to identify the target outcome or desired state of affairs which the Function is designed to deliver.  If the Function does the job which it is supposed to do, what will it change or achieve.<br/><br/>
             Examples of target outcomes are:<ul> <li>A narrowing of the gap between the local employment rate for priority disadvantaged groups and the national rate.</li>
             <li>An improvement in the skill levels of the workforce to better meet the needs of the local economy.</li></ul> It is unlikely that the target outcome will be expressed in terms of numerical targets or outputs."
      add_value :existing_policy =>  "This question asks you to identify the target outcome or desired state of affairs which the Policy is designed to deliver.  If the Policy does the job which it is supposed to do, what will it change or achieve.<br/><br/>
             Examples of target outcomes are:<ul> <li>A narrowing of the gap between the local employment rate for priority disadvantaged groups and the national rate.</li>
             <li>An improvement in the skill levels of the workforce to better meet the needs of the local economy.</li></ul> It is unlikely that the target outcome will be expressed in terms of numerical targets or outputs."
      add_value :proposed_policy => "This question asks you to identify the target outcome or desired state of affairs which the Policy is designed to deliver.  If the Policy does the job which it is supposed to do, what will it change or achieve.<br/><br/>
             Examples of target outcomes are:<ul> <li>A narrowing of the gap between the local employment rate for priority disadvantaged groups and the national rate.</li>
             <li>An improvement in the skill levels of the workforce to better meet the needs of the local economy.</li></ul> It is unlikely that the target outcome will be expressed in terms of numerical targets or outputs."
    end
    
    #purpose_overall_5 help text
    add_seed :help_text, :question_name => 'purpose_overall_5' do 
      add_value :existing_function => "Service Users, people who use Council serices whether residents or visitors.  Functions which deliver front line services will have an impact on these individuals."
      add_value :proposed_function => "Service Users, people who use Council serices whether residents or visitors.  Functions which deliver front line services will have an impact on these individuals."
      add_value :existing_policy =>  "Service Users, people who use Council serices whether residents or visitors.  Policies which deliver front line services will have an impact on these individuals."
      add_value :proposed_policy => "Service Users, people who use Council serices whether residents or visitors.  Policies which deliver front line services will have an impact on these individuals."
    end    
    
    #purpose_overall_6 help text
    add_seed :help_text, :question_name => 'purpose_overall_6' do 
      add_value :existing_function => "Functions on how the Council is structured and operates such as HR Functions will have an impact on staff employed by the Council.  Staff are almost certain to be Services Users as well but this question is asked in relation to their role as staff."
      add_value :proposed_function => "Functions on how the Council is structured and operates such as HR Functions will have an impact on staff employed by the Council.  Staff are almost certain to be Services Users as well but this question is asked in relation to their role as staff."
      add_value :existing_policy =>  "Policies on how the Council is structured and operates such as HR Policies will have an impact on staff employed by the Council.  Staff are almost certain to be Services Users as well but this question is asked in relation to their role as staff."
      add_value :proposed_policy => "Policies on how the Council is structured and operates such as HR Policies will have an impact on staff employed by the Council.  Staff are almost certain to be Services Users as well but this question is asked in relation to their role as staff."
    end 
      
    #purpose_overall_7 help text
    add_seed :help_text, :question_name => 'purpose_overall_7' do 
      add_value :existing_function => "Functions relating to the way in which the Council purchases goods and services may have an impact on staff employed by supplier organisations.  Staff of supplier organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of supplier organisations."
      add_value :proposed_function => "Functions relating to the way in which the Council purchases goods and services may have an impact on staff employed by supplier organisations.  Staff of supplier organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of supplier organisations."
      add_value :existing_policy =>  "Policies relating to the way in which the Council purchases goods and services may have an impact on staff employed by supplier organisations.  Staff of supplier organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of supplier organisations."
      add_value :proposed_policy => "Policies relating to the way in which the Council purchases goods and services may have an impact on staff employed by supplier organisations.  Staff of supplier organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of supplier organisations."
    end
    
    #purpose_overall_8 help text
    add_seed :help_text, :question_name => 'purpose_overall_8' do 
      add_value :existing_function => "Functions that cover the way the Council works with local partners are likely to affect staff of partner organisations.  Staff of partner organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of partner organisations."
      add_value :proposed_function => "Functions that cover the way the Council works with local partners are likely to affect staff of partner organisations.  Staff of partner organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of partner organisations."
      add_value :existing_policy =>  "Policies that cover the way the Council works with local partners are likely to affect staff of partner organisations.  Staff of partner organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of partner organisations."
      add_value :proposed_policy => "Policies relating to the way in which the Council purchases goods and services may have an impact on staff employed by supplier organisations.  Staff of supplier organisations are almost certain to be Services Users as well but this question is asked in relation to their role purely as staff of supplier organisations."
    end
    
    #purpose_overall_9 help text
    add_seed :help_text, :question_name => 'purpose_overall_9' do 
      add_value :existing_function => "Functions which cover the way in which the Council engages with businesses are likely to have an impact on the employees of such businesses"
      add_value :proposed_function => "Functions which cover the way in which the Council engages with businesses are likely to have an impact on the employees of such businesses"
      add_value :existing_policy =>  "Policies which cover the way in which the Council engages with businesses are likely to have an impact on the employees of such businesses"
      add_value :proposed_policy => "Policies which cover the way in which the Council engages with businesses are likely to have an impact on the employees of such businesses"
    end 

    #purpose_overall_11 help text
    add_seed :help_text, :question_name => 'purpose_overall_11' do 
      add_value :existing_function => ""
      add_value :proposed_function => ""
      add_value :existing_policy =>  ""
      add_value :proposed_policy => ""
    end       

    #purpose_overall_12 help text
    add_seed :help_text, :question_name => 'purpose_overall_12' do 
      add_value :existing_function => ""
      add_value :proposed_function => ""
      add_value :existing_policy =>  ""
      add_value :proposed_policy => ""
    end       
    
    HelpText.find(:all).each do |ht|
      ht.existing_function = ht.existing_function.gsub("\n", " ")
      ht.existing_function = ht.existing_function.gsub(/[\s]+/, " ").strip
      ht.proposed_function = ht.proposed_function.gsub("\n", " ")
      ht.proposed_function = ht.proposed_function.gsub(/[\s]+/, " ").strip
      ht.existing_policy = ht.existing_policy.gsub("\n", " ")
      ht.existing_policy = ht.existing_policy.gsub(/[\s]+/, " ").strip
      ht.proposed_policy = ht.proposed_policy.gsub("\n", " ")
      ht.proposed_policy = ht.proposed_policy.gsub(/[\s]+/, " ").strip
      ht.save
    end  
  end

  def self.down
    remove_seed :help_text, :question_name => 'purpose_overall_2'
    remove_seed :help_text, :question_name => 'purpose_overall_5'
    remove_seed :help_text, :question_name => 'purpose_overall_6'
    remove_seed :help_text, :question_name => 'purpose_overall_7'
    remove_seed :help_text, :question_name => 'purpose_overall_8'
    remove_seed :help_text, :question_name => 'purpose_overall_9'
    remove_seed :help_text, :question_name => 'purpose_overall_11'
    remove_seed :help_text, :question_name => 'purpose_overall_12'
  end
end
