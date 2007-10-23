class StatFunction
  RELEVANCE = 0.35
  RANKING = [0.8,0.7,0.6,0.5]
  MAXRATING = 5
  attr_reader :topics, :function
  def initialize(topics, function)
    @topics = topics
    @function = function
  end
  def score(questions)
    @topics.each{|name, topic| topic.score(questions[name])}
  end
  def relevant(topic)
    return (@topics[topic].purpose_result.to_f > RELEVANCE)
  end
  def priority_ranking(topic)
    result = @topics[topic].result
    rank = MAXRATING
    RANKING.each{|border| rank -= 1 unless result > border}
    return rank
  end
  def fun_relevance
    rel = true
    @topics.each{|name, topic| rel = rel && (topic.purpose_result > RELEVANCE)}
    return rel
  end
  def fun_priority_ranking
    total = 0
    count = 0
    @topics.each{|key, topic| total += priority_ranking(topic.name); count +=1 }
    return total/count
  end
  def impact
	  impact = 5
	  @topics.each{|topic| impact = topic.impact if topic.impact > impact}
	return numtorank(impact)
  end
  private
  def numtorank(num)
    case num
      when 15
        return :high
      when 10
        return :medium
      when 5
        return :low
    end
  end
end
class StatTopic
  attr_reader :impact, :result, :name, :purpose_result, :max, :questions
  def initialize(questions, name)
    @name = name
    @questions = questions
    @topic_max = 0
    @impact = 0
    @result = 0
    @purpose_result = 0
    @purpose_max = 0
    @questions.each_value{|question| @topic_max += question.max}
    @questions.each_value{|question| @purpose_max += question.max if question.name.to_s.include("purpose")}
  end
  def score(results)
    results.each{|question_name, lookup_result| @questions[question_name].score(lookup_result)}
    total = 0
    existence = @function[:overall][:purpose_overall_1].score
    total += existence
    @questions.each_value{|question| total += question.scores}
    @result = total.to_f/@topic.max
    @questions.each_value do |question| # This checks for all purpose questions
	name = question.name.to_s
	if name.include?("purpose") then
		unless @impact > question.score then
			@impact = question.score
		end
	end
   end
    purpose_total = 0
    @questions.each_value{|question| purpose_total += question.score if (question.name.to_s.include?("purpose"))}
    @purpose_result = (purpose_total.to_f + existence)/@purpose_max    
  end
end
class StatQuestion
  attr_reader :name, :scores, :max
  def initialize(lookups, name)
    @name = name
    @max = 0
    @scores = 0
    @lookup = lookup
    lookups.each{|lookup| @max = lookup.weight unless lookup.weight < @max}
  end
  def score(response)
    @scores = 0
    @lookup.each{|lookup_option| @scores = lookup_option.weight if lookup_option.value == response}
    return @scores
  end
end

class Statistics
  attr_reader :function
  def initialize(question_wording_lookup)  
    topic_hash = {}
    questions = question_wording_lookup
    questions.each do |strand_name, strand|
	strand.each do |section_name, section|
		section.each do |question, value|
			topic_hash[strand_name] = {"#{section_name.to_s}_#{strand_name.to_s}_#{question.to_s}".to_sym => value[1]}
		end
	end
    end
    #replace all the symbol references to lookups with the lookup itself, and initialize the question.
    topic_hash.each{|topic| topic.each{|question, value| topic_hash[topic][question] = StatQuestion.new(Look_up.find_by_look_up_type(value), question)}}
    #replace all the topic symbols with a StatTopic object
    stat_topics = {}
    topics.each{|topic| stat_hash[topic] = StatTopic.new(topic_hash[topic], topic)} 
    #create a StatFunction from the hash
    @function = StatFunction.new(stat_topics)
  end
  def score(results, function)
    @function.score(results, function) if results
  end
end