class StatFunction
  RELEVANCE = 0.35
  RANKING = [0.8,0.7,0.6,0.5]
  MAXRATING = 5
  attr_reader :topics
  def initialize(topics)
    @topics = topics
  end
  def score(questions)
    temp = {}
    questions.each{|k,v| temp[k.to_s] = v}
    questions = temp
    @topics.each{|name, topic| topic.score(questions)}
  end
  def relevant(topic)
    return (@topics[topic].presult.to_f > RELEVANCE)
  end
  def priority_ranking(topic)
    result = @topics[topic.to_s].result
    rank = MAXRATING
    RANKING.each{|border| unless result > border then rank -= 1 end}
    return rank
  end
  def impact(topic)
    topic = topic.to_s
    return numtorank(@topics[topic].impact)
  end
  def fun_relevance
    rel = true
    @topics.each{|name, topic| rel = rel && (topic.presult > RELEVANCE)}
    return rel
  end
  def fun_priority_ranking
    total = 0
    count = 0
    @topics.each{|key, topic| total += priority_ranking(topic.name); count +=1 }
    return total/count
  end
  def fun_impact
    retval = 5
    @topics.each{|name, topic| retval = topic.impact unless retval > topic.impact}
    return numtorank(retval)
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
  attr_reader :impact, :result, :name, :presult, :purpquest, :max
  def initialize(purpquestions, perfquestions, name)
    @name = name
    @purpquest = purpquestions
    @funquest= perfquestions
    @presult = 0
    @fresult = 0
    @pmax = 0
    @fmax = 0
    @result = 0
    @impact = 0
    @purpquest.values.each{|question| @pmax += question.max}
    @funquest.values.each{|question| @fmax += question.max}
    @max = @pmax + @fmax
  end
  #The score method works by taking a hash of questions and responses, and retrieving the score from them. If the question doesn't exist
  #the score returned is 0. This allows the function to operate on the topics by simply throwing it the entire set of questions, as each topic will only respond
  #to the questions it contains and ignore the others as they add the identity element (0). This would be a LOT nicer method if I didn't have to track the two 
  #different values for purpose and function. An alternative implementation would be to use one loop, and have a purpose flag in the question itself, multiplying
  # the result by the flag(leave it as 0 for false and 1 for true). Hence, in one loop round, it would assign the purpose and then recalculate the same thing again
  # without the flag multiplier for the total. I left it as is, because it makes no speed difference, and if someone wants to play around with the performance, although
  # it is currently messier, it gives them the option of accessing the performance question results too. Could do with refactoring to replace fun with perf etc.
  def score(results)
    pres = 0
    results.each do
      |question, response|
      response = if @purpquest[question] then @purpquest[question].score(response) else 0 end
      response = response.to_i
      @impact = response unless @impact > response
      pres += response
    end
    unless pres == 0 && @pmax == 0 then @presult = (pres.to_f/@pmax.to_f) else @presult = 0 end
    fres = 0
    results.each do
      |question, response|
      response = response.to_i
      fres += if @funquest[question] then @funquest[question].score(response) else 0 end
    end
    @fresult = (fres.to_f/@fmax.to_f)
    @result = (@presult+@fresult)/2
  end
  #This is needed to be able to add existence status
  def inc_pmax(increment)
    @pmax += increment
  end
  def inc_fmax(increment)
    @fmax += increment
  end
end
class StatQuestion
  attr_reader :name, :scores, :max
  def initialize(max, name)
    @name = name
    @max = max
    @scores = 0
  end
  def score(response)
    @scores = response
  end
end

class Statistics
  attr_reader :function
  def initialize  
    responses = {:validated => 0,
    :good => 15,
    :bad => 15,
    :performance => 30,
    :issues => 10, :status => 15}
    topics = [:gender, :race, :disability, :faith, :sex, :age, :overall]
    purposequestions = [:good_gender,:good_race,:good_disability,:good_faith,:good_sexual_orientation,
    :good_age,:bad_gender,:bad_race,:bad_disability,:bad_faith,:bad_sexual_orientation,:bad_age,
    :existence_status]
    perfquestions = [:overall_performance, :overall_validated, :overall_issues, :gender_performance,
    :gender_validated, :gender_issues, :race_performance, :race_validated, :race_issues, :disability_performance,
    :disability_validated, :disability_issues, :faith_performance, :faith_validated, :faith_issues, 
    :sexual_orientation_performance, :sexual_orientation_validated, :sexual_orientation_issues,
    :age_performance, :age_validated,:age_issues]
    purpq = []
    purposequestions.each do
      |question|
      max = 0
      responses.each{|name, mx| if question.to_s.include?(name.to_s) then max = mx end}
      purpq.push(StatQuestion.new(max, question.to_s))
    end
    perfq = []
    perfquestions.each do
      |question|
      max = 0
      responses.each{|name, mx| if question.to_s.include?(name.to_s) then max = mx end}
      perfq.push(StatQuestion.new(max, question.to_s))
    end
    newtopics = {}
    topics.each do
      |topic|
      tperfq = {}
      tpurpq = {}
      perfq.each{|quest| if quest.name.include?(topic.to_s) then tperfq[quest.name] = quest end}
      purpq.each{|quest| if quest.name.include?(topic.to_s) then tpurpq[quest.name] = quest end}
      exist = StatQuestion.new(15, "existence_status")
      tpurpq[exist.name] = exist
      newtopics[topic.to_s] = (StatTopic.new(tpurpq, tperfq, topic.to_s))
    end
    @function = StatFunction.new(newtopics)
  end
  def score(results)
    @function.score(results) if results
  end
end