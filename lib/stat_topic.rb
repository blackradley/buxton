#This class simulates a single strand.
class StatTopic
  attr_reader :impact, :result, :name, :purpose_result, :topic_max, :questions
  #Simply initalizes all values and calculates the maximum value for each question
  def initialize(questions, name)
    @name = name
    @questions = questions
    @topic_max = 0
    @impact = 0
    @result = 0
    @purpose_result = 0
    @purpose_max = 0
    @questions.each_value{|question| @topic_max += question.max}
    @questions.each_value{|question| @purpose_max += question.max if question.name.to_s.include?("purpose")}
  end
  #This scores a topic. It works by scoring each question individually, and totalling them.
  #The existence status is essentially a global variable that affects every topic, hence why it is hardcoded in.
  #It is also necessary to calculate purpose questions separately for the impact level they have, hence why that is separate.
  def score(results, function)
    results.each{|question_name, lookup_result| if @questions[question_name] then @questions[question_name].score(lookup_result) end}
    total = 0
    existence = function.topics['overall'].questions[:existing_proposed].scores
    total += existence
    @questions.each_value{|question| total += question.scores}
    @result = total.to_f/(@topic_max+20) # +20 is added to both totals to compensate for existence status.
    @questions.each_value do |question| # This checks for all purpose questions
      name = question.name.to_s
      if name.include?("purpose") then
        unless @impact > question.scores then
          @impact = question.scores
        end
      end
    end
    purpose_total = 0
    @questions.each_value{|question| purpose_total += question.scores if (question.name.to_s.include?("purpose"))}
    @purpose_result = (purpose_total.to_f + existence)/(@purpose_max + 20)   
  end
end