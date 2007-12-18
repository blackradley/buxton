class YmlActivityGenerator
  
  DISPLAYTEXT = "Lorem ipsum dolor sit amet consectetuer adipiscing elit."
  @@running_count = 0
  @@issue_id = 0
  @@names = ["Time off for trade union duties and activities",
    "Extra-curricular activities",
    "Guide to leisure pursuits for over 50s",
    "Study support",
    "Improving your reading, writing and number skills",
    "Sport and fitness",
    "UK Deaf Sport",
    "Leisure",
    "Mind the Gap",
    "Sports facilities and events",
    "Developing maths skills for five to 11 year olds",
    "Report suspect activity to MI5",
    "Jubilee Sailing Trust",
    "Theft resistant number plates",
    "Mencap",
    "Corporate Social Responsibility",
    "Cerebral Palsy Sport",
    "Office of Government Commerce"]
    
  def initialize(number = @@running_count, name = nil, directorate = nil, actman = 'actman_iain', type = nil)
    @file = []
    @number = number
    @hashes = YAML.load_file("#{RAILS_ROOT}/config/questions.yml")
    @@running_count += 1
    @issues = []
    name = @@names[rand(@@names.size)]
    @name = name
    directorate = "directorate_#{rand(4)+1}"
    generate_activity_start(name, directorate, actman) if name
    generate_activity_text(type) if type
  end 
  def generate_activity_text(type) 
    [@hashes['questions'], @hashes['overall_questions']].each do |question_set|
      Activity.get_question_names.each do |question| 
        question_parts = Activity.question_separation(question)
        begin
          case question_set[question_parts[0].to_s][question_parts[2].to_i]['type'] 
            when 'select' 
              case type
     	          when :random
                  @file << "#{question}: #{rand(3)}"
                when :yes 
                  @file << "#{question}: #{1}" 
    	          when :no 
    	            @file << "#{question}: #{2} "
                when :random_complete
                  @file << "#{question}: #{rand(2) + 1}"
                  @file << "function_policy: #{rand(2) + 1}"
                  @file << "existing_proposed: #{rand(2) + 1}"
              end 
            when 'text' 
              @file << "#{question}: #{DISPLAYTEXT}" 
          end
        rescue
        end
      end
    end
  end 
  def generate_issues
    sections = [:impact, :consultation]
    strands = [:gender, :race, :disability, :faith, :sexual_orientation, :age]
    issues = rand(25)
    issues.times do
      @issues << ["strand: #{strands[rand(6)]}", "activity: activity_#{@number}", "description: #{generate_random_text}", "section: #{sections[rand(2)]}"]
    end
    return @issues
  end
  def generate_random_text
    text = DISPLAYTEXT.split(" ")
    return_text = ""
    5.times do
      return_text << "#{text[rand(8)]} "
    end
    return return_text.titleize
  end
  def generate_activity_start(name, directorate = 'directorate_1', actman = 'actman_iain')
    @file << "name:  #{name}"
    @file << "directorate:  #{directorate}"
    @file << "activity_manager:  #{actman}"
  end
  def issue_to_s
    output = ""
    results = generate_issues
    results.each do |result|
      output << "\nissue_#{@@issue_id}:\n"
      result.each{|line| output << "  #{line}\n"}
      output += "\n"
      @@issue_id += 1
    end
    output
  end
  def self.to_yaml(numbers = nil, names = nil, directorates = 'directorate_1', actmans = 'actman_iain', types = :random)
    numbers = 1 unless numbers
    numbers = 1..numbers unless numbers.class == Array || numbers.nil?
    unless numbers.nil? || names then
      names = (1..numbers.to_a.size).to_a 
      names.map{@@names[rand(@@names.size)]}
    end
    numbers = 1..names.size unless names.nil? || numbers
    numbers.each do |number|
      if actmans.class == Array then
        manager = actmans.pop
      else
        manager = actmans    
      end
      if directorates.class == Array then
        directorate = directorates.pop
      else
        directorate = directorates    
      end
      if types.class == Array then
        type = types.pop
      else
        type = types    
      end
      if names.class == Array then
        name = names.pop
      else
        name = names    
      end
      File.open("#{RAILS_ROOT}/spec/fixtures/activities.yml", 'a') do |yaml|
        yaml.puts self.new(number, name, directorate, manager, type)
      end
      File.open("#{RAILS_ROOT}/spec/fixtures/issues.yml", 'a') do |yaml|
        yaml.puts self.new(number, name, directorate, manager, type).issue_to_s
      end
    end
  end
  def to_s
    output = @file.inject("\nactivity_#{@number}:\n"){|string, line| string += "  #{line}\n"}
    output << "  function_policy: #{rand(2) + 1}\n"
    output << "  existing_proposed: #{rand(2) + 1}\n"
    output += "\n"
    output
  end
end