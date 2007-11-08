#  
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2007 Black Radley Systems Limited. All rights reserved. 
#
require 'stat_function.rb'
require 'stat_topic.rb'
require 'stat_question.rb'

#This is the main class that is initialized in the function model.
#It contains the function object, which can then be referenced externally. and tested on. 
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