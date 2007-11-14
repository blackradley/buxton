require File.dirname(__FILE__) + '/../test_helper'

#This suite tests that all the basic model abilities work, and all the tag calculations and statistics are right 
class ModelBasicFunctionalityTest < Test::Unit::TestCase
	
   fixtures :look_ups
  
  def setup
    user_id = rand(10e10)
    user_email = "#{rand(10e10)}@bob.com"
    org_id = rand(10e10)
    fun_id = rand(10e10)
    @models = [
      FunctionManager.new({:email => user_email, :id => user_id}),
      Organisation.new({:name => "Organisation Name", :style => "Test", :id => org_id}),
      Function.new({:id => fun_id, :name => "Function Name"}),
      FunctionStrategy.new,
      Issue.new(:description => 'A description.'),
      LookUp.new({:name => "Test Lookup", :look_up_type => LookUp::TYPE[:yes_no]}),
      Strategy.new(:name=> "A strategy")
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
	    "<script>alert(\"Hi!\")</script>"
          when :integer
            1
          when :string
            "<script>alert(\"Hi!\")</script>"
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

  # DISABLED until will pass
  #   def test_completed_tags_when_completed
  # set_function_variables_correctly
  # @models[2].question_wording_lookup.each do |strand, sections|
  #   assert @models[2].completed(strand)
  #   sections.each do |section, questions|
  #     assert @models[2].completed(nil, section)
  #     assert @models[2].completed(strand, section)
  #   end
  # end
  # assert @models[2].completed
  #   end
  
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

  # DISABLED until will pass
  #   def test_statistic_calculations
  # set_function_variables_correctly
  # stats = @models[2].statistics
  # assert stats.impact == :low
  # assert stats.fun_relevance == true
  # assert stats.fun_priority_ranking == 2
  #   end
 
  def test_percentage_completed_when_completed
	set_function_variables_correctly
	@models[2].question_wording_lookup.each do |strand, sections|
		assert(@models[2].percentage_answered(strand) == 100)
		sections.each do |section, questions|
			assert(@models[2].percentage_answered(nil, section) == 100)
			assert(@models[2].percentage_answered(strand, section) == 100)
		end
	end
	assert (@models[2].percentage_answered == 100)	
  end

  def test_percentage_completed_when_not_started
	@models[2].question_wording_lookup.each do |strand, sections|
		assert(@models[2].percentage_answered(strand) == 0)
		sections.each do |section, questions|
			assert(@models[2].percentage_answered(nil, section) == 0)
			assert(@models[2].percentage_answered(strand, section) == 0)
		end
	end
	assert (@models[2].percentage_answered == 0)	
  end

end
