# Load entire question hash into memory
@@Hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml")
@@question_max = 0
Activity.force_question_max_calculation
@@dependencies = {}
@@Hashes['questions'].each do |section, section_data|
  section_data.each do |question_name, question_data|
    @@Hashes['wordings'].keys.each do |strand|
      unless question_data.values[4].blank? then
        temp = question_data.values[4].split(" ")
        temp[0]=  eval(%Q{<<"DELIM"\n} + temp[0] + "\nDELIM").chomp
        @@dependencies[temp[0]] = ["#{section}_#{strand}_#{question_name}", temp[1]]
      end
    end
  end
end