require 'seed_extensions'
include Seed

# Load entire question hash into memory
@@Hashes = YAML.load_file("#{Rails.root}/config/questions.yml")
@@age_max = 0
@@gender_max = 0
@@faith_max = 0
@@sexual_orientation_max = 0
@@race_max = 0
@@disability_max = 0
begin
  Activity.force_question_max_calculation
rescue
end
@@dependencies = {}
@@invisible_questions = []
@@weighted_questions = []
@@parents = {}
@@weight_ids = {}
@@Hashes['questions'].each do |section, section_data|
  section_data.each do |question_name, question_data|
    @@Hashes['wordings'].keys.each do |strand|
      @@invisible_questions.push("#{section}_#{strand}_#{question_name}".to_sym) if question_data['label'][0][1].blank?
      @@weighted_questions << ["#{section}_#{strand}_#{question_name}", @@Hashes['weights'][question_data['weights']]] if question_data['weights'].to_i != 0
      @@weight_ids["#{section}_#{strand}_#{question_name}".to_sym] = question_data['weights']
      unless question_data['dependent_questions'].blank? then
        temp = question_data['dependent_questions'].split(" ")
        temp[0]=  eval(%Q{<<"DELIM"\n} + temp[0] + "\nDELIM").chomp
        @@parents["#{section}_#{strand}_#{question_name}"] = [temp[0], @@Hashes[temp[1]]]
        @@dependencies[temp[0]] = [] if @@dependencies[temp[0]].nil?
        @@dependencies[temp[0]].push(["#{section}_#{strand}_#{question_name}", temp[1]])
      end
    end
  end
end
@@Hashes['overall_questions'].each do |section, section_data|
  section_data.each do |question_name, question_data|
    @@weighted_questions << ["#{section}_overall_#{question_name}", @@Hashes['weights'][question_data['weights']]] if question_data['weights'].to_i != 0
    unless question_data['dependent_questions'].blank? then
      temp = question_data['dependent_questions'].split(" ")
      temp[0]=  eval(%Q{<<"DELIM"\n} + temp[0] + "\nDELIM").chomp
      @@parents["#{section}_overall_#{question_name}"] = [temp[0], @@Hashes[temp[1]]]
      @@dependencies[temp[0]] = [] if @@dependencies[temp[0]].nil?
      @@dependencies[temp[0]].push(["#{section}_overall_#{question_name}", temp[1]])
    end
  end
end
@@dependencies.each do |dependent, children|
  parent_value = Hash[*@@dependencies[@@parents[dependent][0]].flatten][dependent] if @@parents[dependent]
  @@dependencies[@@parents[dependent][0]] << children.map{|child, value| [child, parent_value]}.flatten if @@parents[dependent]
end
