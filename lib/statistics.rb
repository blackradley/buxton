#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
#This function simulates an actual function. The statistics is modeled as closely to the structure of the actual database as possible
# in order so that changes are simple and intuitive.
class StatFunction
  RELEVANCE = 0.35 #Define the relevance boundary
  RANKING = [0.8,0.7,0.6,0.5] #Define the boundaries for priority rankings
  MAXRATING = 5 #Define the maximum priority ranking possible.
  #Make the function and it's topics publically accessible. Topics COULD be referenced by .function.topic, but is used frequently 
  #enough that it warrants a separate attrreader for readability purposes.
  attr_reader :topics, :function 
  def initialize(topics, function)
    @topics = topics
    @function = function
  end
  #This loops through each question, separating them out into individual topic matters, then calling score for each topic.
  def score(questions)
    @topics.each do |name, topic|
	question_hash = {}
	questions.each_key{|key| question_hash[key] = questions[key] if key.to_s.include?(name.to_s)}
	topic.score(question_hash, self)
    end
  end
  #This checks the relevance is higher than the relevance boundary
  def relevant(topic)
    return (@topics[topic].purpose_result.to_f > RELEVANCE)
  end
  #This returns the priority ranking
  def priority_ranking(topic)
    result = @topics[topic].result
    rank = MAXRATING
    RANKING.each{|border| rank -= 1 unless result > border}
    return rank
  end
  #This checks that every topic has its border less than the relevance boundary if it has questions in it
  def fun_relevance
    rel = true
    @topics.each{|name, topic| (rel = rel && (topic.purpose_result < RELEVANCE)) unless topic.topic_max == 0}#TODO: A section with all negative responses would not be counted here.
    return !rel
  end
  #This calculates the function priority ranking by averaging all the previous values. The +0.5 is for accurate float => int conversions.
  #TODO: count and total should be called opposite things?
  def fun_priority_ranking
    total = 0
    count = 0
    @topics.each{|key, topic| (total += priority_ranking(topic.name); count +=1 ) unless topic.topic_max == 0}
    return (total.to_f/count.to_f + 0.5).to_i
  end
  #This calculates what impact level a function will have (it's highest value)
  def impact
	  impact = 5
	  @topics.each_value{|topic| impact = topic.impact if topic.impact > impact}
	return numtorank(impact)
  end
  private
  #This is used to convert the impact value to a word.
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
#This simulates a strand.
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
    existence = function.topics[:overall].questions[:purpose_overall_1].scores
    total += existence
    @questions.each_value{|question| total += question.scores}
    @result = total.to_f/(@topic_max+15) # +15 is added to both totals to compensate for existence status.
    @questions.each_value do |question| # This checks for all purpose questions
	name = question.name.to_s
	if name.include?("purpose")&& name != "purpose_overall_1" then
		unless @impact > question.scores then
			@impact = question.scores
		end
	end
   end
    purpose_total = 0
    @questions.each_value{|question| purpose_total += question.scores if (question.name.to_s.include?("purpose"))}
    @purpose_result = (purpose_total.to_f + existence)/(@purpose_max + 15)   
  end
end
#This simulates a single question. It contains a name, the maximum value of the question, and the lookup of the question.
class StatQuestion
  attr_reader :name, :scores, :max
  #This sets all the values, and sets the maximum values.
  def initialize(value, name)
    @name = name
    @max = 0
    @scores = 0
    unless value == :text || value == :string then
	@lookup = LookUp.send(value)
	@lookup.each{|lookup| @max = lookup.attributes["weight"] unless (@max >= lookup.attributes["weight"])}
    else
	@max = 0
    end
  end
  #This returns the score of the question to a particular response. Text questions are automatically scored 0.
  #Hence, this is why it is possible to have a section with a score of 0, as (for example, as action planning is) it
  #could be full of text questions with no lookups with values.
  def score(response)
    @scores = 0
    return 0 unless @lookup
    @lookup.each{|lookup_option| @scores = lookup_option.attributes["weight"] if lookup_option.attributes["value"] == response}
    return @scores
  end
end

#This is the main class. It contains the function object, which can then be referenced externally. and tested on. 
#TODO: Make aliases that point to the function methods..so for example, def stats.impact; @function.impact; end.
class Statistics
  attr_reader :function
  def initialize(question_wording_lookup, function)  
    topic_hash = {}
    questions = question_wording_lookup
    questions.each do |strand_name, strand|
	strand.each do |section_name, section|
		section.each do |question, value|
			topic_hash[strand_name] = {} unless topic_hash[strand_name]
			topic_hash[strand_name] ["#{section_name.to_s}_#{strand_name.to_s}_#{question.to_s}".to_sym] = value[1]
		end
	end
    end
    #replace all the symbol references to lookups with the lookup itself, and initialize the question.
    topic_hash.each{|topic_name, topic| topic.each{|question, value| topic_hash[topic_name][question] = StatQuestion.new(value, question)}}
    #replace all the topic symbols with a StatTopic object
    stat_topics = {}
    questions.each_key{|strand_name| stat_topics[strand_name] = StatTopic.new(topic_hash[strand_name], strand_name)} 
    #create a StatFunction from the hash
    @function = StatFunction.new(stat_topics, function)
  end
  #TODO: Since it now is passed the function, it should be able to calculate the score itself. This will make the model code much simpler.
  def score(results)
    @function.score(results) if results
  end
end