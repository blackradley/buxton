require 'test/unit'
require 'rubygems'
require File.dirname(__FILE__) + '/../test_helper'


#This suite tests that all the basic model abilities work, such as 
class ModelBasicFunctionalityTests < Test::Unit::TestCase

  def setup
    user_id = rand(10e10)
    user_email = "#{rand(10e10)}@bob.com"
    org_id = rand(10e10)
    fun_id = rand(10e10)
    @models = [
      User.new({:email => user_email, :id => user_id}),
      Organisation.new({:name => "Organisation Name", :style => "Test", :id => org_id}),
      Function.new({:id => fun_id, :name => "Function Name"}),
      FunctionStrategy.new,
      Issue.new,
      LookUp.new({:name => "Test Lookup"}),
      Strategy.new({:name=> "A strategy", :display_order => 1})
    ]
    @models[1].user = @models[0]
    @models[2].user = @models[0]
    @models[2].organisation = @models[1]
  end
  
  def teardown
    @models.each{|model| model.destroy}
  end
  
  def test_all_save_correctly
    @models.each{|model| assert model.save}
  end
  
  def all_set_variables_correctly
    @models.each do |model|
      columns = model.class.content_columns
      columns.each do |column|
        sample_data = case column.type
          when :text
	    "Sample Text"
          when :integer
            1
          when :string
            "Sample String"
          when :datetime
            Date.today()
        end
	model.update_attribute(column.name.to_sym, sample_data)
      end
    end
  end
  
  def set_function_variables_correctly
      model = @models[2]
      columns = model.class.content_columns
      columns.each do |column|
        sample_data = case column.type
          when :text
	    "Sample Text"
          when :integer
            1
          when :string
            "Sample String"
          when :datetime
            Date.today()
        end
	model.update_attribute(column.name.to_sym, sample_data)
     end
  end
  
  def test_completed_tags_when_completed
	set_function_variables_correctly
	@models[2].question_wording_lookup.each do |strand, sections|
		assert @models[2].completed(strand)
		sections.each do |section, questions|
			assert @models[2].completed(nil, section)
			assert @models[2].completed(strand, section)
		end
	end
	assert @models[2].completed
  end
  
  def test_overall_completed_tags_when_not_started
	@models[2].question_wording_lookup.each do |strand, sections|
		assert !@models[2].completed(strand)
		sections.each do |section, questions|
			assert !@models[2].completed(nil, section)
			assert !@models[2].completed(strand, section)
		end
	end
	assert !@models[2].completed
  end
  
  def test_started_tags_when_not_started
	@models[2].question_wording_lookup.each do |strand, sections|
		assert !@models[2].started(strand)
		sections.each do |section, questions|
			assert !@models[2].started(nil, section)
			assert !@models[2].started(strand, section)
		end
	end
	assert !@models[2].started
  end
 
  def test_started_tags_when_started
	set_function_variables_correctly
	@models[2].question_wording_lookup.each do |strand, sections|
		assert @models[2].started(strand)
		sections.each do |section, questions|
			assert @models[2].started(nil, section)
			assert @models[2].started(strand, section)
		end
	end
	assert @models[2].started
  end
  
  def test_statistic_calculations
	set_function_variables_correctly
	stats = @models[2].statistics
	assert stats.impact == :low
	assert stats.fun_relevance == true
	assert stats.fun_priority_ranking == 2
  end
end
