# Load entire question hash into memory
@@Hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml")
@@Statistics = Statistics.new