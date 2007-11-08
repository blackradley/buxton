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
    existing_proposed = StatQuestion.new(:existing_proposed, "existing_proposed")
    @topics[:overall].questions[:existing_proposed] = existing_proposed
  end
  #This loops through each question, separating them out into individual topic matters, then calling score for each topic.
  def score(questions)
    @topics[:overall].questions[:existing_proposed].score(@function.send(:existing_proposed))
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