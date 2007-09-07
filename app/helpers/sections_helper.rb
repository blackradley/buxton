module SectionsHelper
  #
  # If the strategy response is not set for a function, return 0 instead.
  # 
  def strategy_response_or_zero(function_responses, id)
    function_response = function_responses.find_by_strategy_id(id)
    if function_response.nil?
      return 0
    else
      return function_response.strategy_response
    end
  end
  
  # String resources
  # ================
  
  # 
  # Hash of impact groups, because they are used in a number of places. 
  #    
     $impact_groups = {
      'service_users'=>'Service users', 
      'staff'=>'Staff employed by the council', 
      'supplier_staff'=>'Staff of supplier organisations', 
      'partner_staff'=>'Staff of partner organisations', 
      'employees'=>'Employees of businesses'
      }
  #
  # Hash of equality dimensions questions, I figured that they might be used in a 
  # number of different places.
  #
    $equality_questions = {
      'good_age'=>'Would it affect different <strong>age groups</strong> differently?', 
      'good_race'=>'Would it affect different <strong>Ethnic groups</strong> differently?', 
      'good_gender'=>'Would it affect <strong>men and women</strong> differently?',
      'good_sexual_orientation'=>'Would it affect people of different <strong>sexual orientation</strong> differently?',
      'good_faith'=>'Would it affect different <strong>faith groups</strong> differently?',
      'good_disability'=>'Would it affect <strong>people with different kinds of disabilities</strong> differently?',
      'bad_age'=>'Would it affect different <strong>age groups</strong> differently?', 
      'bad_race'=>'Would it affect different <strong>Ethnic groups</strong> differently?', 
      'bad_gender'=>'Would it affect <strong>men and women</strong> differently?',
      'bad_sexual_orientation'=>'Would it affect people of different <strong>sexual orientation</strong> differently?',
      'bad_faith'=>'Would it affect different <strong>faith groups</strong> differently?',
      'bad_disability'=>'Would it affect <strong>people with different kinds of disabilities</strong> differently?'
      }
  
end
