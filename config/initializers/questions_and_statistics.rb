# Load entire question hash into memory
@@Hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml")
@@question_max = 0
Activity.force_question_max_calculation