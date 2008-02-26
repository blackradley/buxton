# Load entire question hash into memory
@@Hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml")
@@age_max = 0
@@gender_max = 0
@@faith_max = 0
@@sexual_orientation_max = 0
@@race_max = 0
@@disability_max = 0
Activity.force_question_max_calculation
@@dependencies = {}
@@invisible_questions = []
@@Hashes['questions'].each do |section, section_data|
  section_data.each do |question_name, question_data|
    @@Hashes['wordings'].keys.each do |strand|
      @@invisible_questions.push("#{section}_#{strand}_#{question_name}".to_sym) if question_data['label'][0][1].blank?
      unless question_data['dependent_questions'].blank? then
        temp = question_data['dependent_questions'].split(" ")
        temp[0]=  eval(%Q{<<"DELIM"\n} + temp[0] + "\nDELIM").chomp
        @@dependencies[temp[0]] = [] if @@dependencies[temp[0]].nil?
        @@dependencies[temp[0]].push(["#{section}_#{strand}_#{question_name}", temp[1]])
      end
    end
  end
end
@@Hashes['overall_questions'].each do |section, section_data|
  section_data.each do |question_name, question_data|
    unless question_data['dependent_questions'].blank? then
      temp = question_data['dependent_questions'].split(" ")
      temp[0]=  eval(%Q{<<"DELIM"\n} + temp[0] + "\nDELIM").chomp
      @@dependencies[temp[0]] = [] if @@dependencies[temp[0]].nil?
      @@dependencies[temp[0]].push(["#{section}_overall_#{question_name}", temp[1]])
    end
  end
end
