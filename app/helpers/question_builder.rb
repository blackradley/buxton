class QuestionBuilder < ActionView::Helpers::FormBuilder    

  # Generates all the HTML needed for a form question
  def question(method, options={})
    strand=options[:equalityStrand].to_sym
    number=options[:number]
    question="#{method}_#{strand}_#{number}"
    # Get the label text for this question
        label = question_wording_lookup(method, strand,number)[0]
      
        # Get the answer options for this question and make an appropriate input field
        input_field = case question_wording_lookup(method, strand,number)[1]      
        when :existing_proposed
          select question, LookUp.existing_proposed.collect {|l| [ l.name, l.value ] }
        when :impact_amount
          select question, LookUp.impact_amount.collect {|l| [ l.name, l.value ] }
        when :impact_level
          select question, LookUp.impact_level.collect {|l| [ l.name, l.value ] }
        when :rating
          select question, LookUp.rating.collect {|l| [ l.name, l.value ] }
        when :yes_no_notsure
          select question, LookUp.yes_no_notsure.collect {|l| [ l.name, l.value ] }
        when :timescales
          select question, LookUp.timescales.collect {|l| [ l.name, l.value ] }
        when :consult_groups
          select question, LookUp.consult_groups.collect {|l| [ l.name, l.value ] }
        when :consult_experts
          select question, LookUp.consult_experts.collect {|l| [ l.name, l.value ] }
        when :text
          text_area question 
        when :string
          text_field question
        end
        
        # Show our formatted question!
        %Q[<p><label for="#{object_name.to_s}_#{question.to_s}">#{label}</label>#{input_field}</p>]
  end
  
  def question_wording_lookup(section, strand, question)
	part_need = "the particular needs of "
	puts section
	puts strand
	puts question
	wordings = {:gender =>  "men and women",
		:race => "individuals from different ethnic backgrounds",
		:disability => "individuals with different kinds of disability",
		:faith => "individuals of different faiths",
		:sexual_orientation => "individuals of different sexual orientations",
		:age => "individuals of different ages",
		:overall => "" #This line is needed, so that when the hash is evaluated it doesn't throw an error. It will never be displayed though.
	}
	strands = {:gender =>  "Gender",
		:race => "Race",
		:disability => "Disability",
		:faith => "Faith",
		:sexual_orientation => "Lesbian Gay Bisexual and Transgender",
		:age => "Age"
	}
	questions = {
		:purpose =>{
			3  => ["If the Function was performed well would it affect #{wordings[strand]} differently?", :impact_level],
			4  => ["If the Function was performed badly would it affect #{wordings[strand]} differently?", :impact_level]
		},
		:performance => {
			1 => ["How would you rate the current performance of the Function in meeting #{part_need + wordings[strand]}?", :rating],
			2 => ["Has this performance assessment been confirmed?", :yes_no_notsure],
			3 => ["Please note the process by which the performance was confirmed", :string],
			4 => ["Are there any performance issues which might have implications for #{wordings[strand]}?", :yes_no_notsure],
			5 => ["Please record any such performance issues for #{wordings[strand]}?", :text]
		},
		:confidence_information => {
			1 => ["Are there any gaps in the information about the Function in relation to #{wordings[strand]}?", :yes_no_notsure],
			2 => ["Are there plans to collect additional information?", :yes_no_notsure],
			3 => ["If there are plans to collect more information what are the timescales?", :timescales],
			4 => ["Are there any other ways by which performance in meeting the #{part_need + wordings[strand]} could be assessed?", :yes_no_notsure],
			5 => ["Please record any such performance measures for #{wordings[strand]}", :text]
		},
		:confidence_consultation => {
			1 => ["Have groups from the #{strands[strand]} Equality Strand been consulted on the potential impact of the Function on #{wordings[strand]}?", :yes_no_notsure],
			2 => ["If no, why is this so?", :consult_groups],
			3 => ["If yes, list groups and dates.", :text],
			4 => ["Have experts from the #{strands[strand]} Equality Strand been consulted on the potential impact of the Function on #{wordings[strand]}?", :yes_no_notsure],
			5 => ["If no, why is this so?",  :consult_experts],
			6 => ["If yes, list groups and dates.", :text],
			7 => ["Did the consultations identify any isues with the impact of the function on #{wordings[strand]}?", :yes_no_notsure],
			8 => ['Please record the issues identified:', :text]
		},
		:additional_work =>{ 
			5 => ["In the light of the information recorded above are there any areas where you feel that you need more information to obtain a comprehensive view of how 
				the Function impacts, or may impact, upon #{wordings[strand]}?", :yes_no_notsure],
			6 => ["Please explain the further information required.", :text],
			7 => ["Is there any more work you feel is necessary to complete the assessment?", :yes_no_notsure],
			8 => ["Do you think that the Function could have a role in preventing #{wordings[strand]} being treated differently, in an unfair way, just because they were #{wordings[strand]}", :text],
			9 => ["Do you think that the Function could have a role in making sure that #{wordings[strand]} were not subject to 
			   inappropriate treatment as a result of their #{strand.to_s.gsub("_"," ")}?", :yes_no_notsure],
			10 => ["Do you think that the Function could have a role in making sure that #{wordings[strand]} were treated equally and fairly?", :yes_no_notsure],
			11 => ["Do you think that the Function could assist #{wordings[strand]} to get on better with each other?", :yes_no_notsure],
			12 => ["Take account of #{strand.to_s.capitalize} even if it means treating #{wordings[strand]} more favourably?", :yes_no_notsure],
			13 => ["Do you think that the Function could assist #{wordings[strand]} to participate more?", :yes_no_notsure],
			14 => ["Do you think that the Function could assist in promoting positive attitudes to #{wordings[strand]}?", :yes_no_notsure]
		},
		:action_planning =>{
			1 => ['Issue 1', :text],
			2 => ['Issue 2', :text],
			3 => ['Issue 3', :text],
			4 => ['Issue 4', :text],
			5 => ['Issue 5', :text],
			6 => ['Actions', :text],
			7 => ['Timescales', :text],
			8 => ['Resources', :text],
			9 => ['Lead Officer', :text],  
			10 => ['Actions', :text],
			11 => ['Timescales', :text],
			12 => ['Resources', :text],
			13 => ['Lead Officer', :text],
			14 => ['Actions', :text],
			15 => ['Timescales', :text],
			16 => ['Resources', :text],
			17 => ['Lead Officer', :text],
			18 => ['Actions', :text],
			19 => ['Timescales', :text],
			20 => ['Resources', :text],
			21 => ['Lead Officer', :text],
			22 => ['Actions', :text],
			23 => ['Timescales', :text],
			24 => ['Resources', :text],
			25 => ['Lead Officer', :text],
			26 => ['Issue 1', :text],
			27 => ['Issue 2', :text],
			28 => ['Issue 3', :text],
			29 => ['Issue 4', :text],
			30 => ['Issue 5', :text],
			31 => ['Actions', :text],
			32 => ['Timescales', :text],
			33 => ['Resources', :text],
			34 => ['Lead Officer', :text],
			35 => ['Actions', :text],
			36 => ['Timescales', :text],
			37 => ['Resources', :text],
			38 => ['Lead Officer', :text],
			39 => ['Actions', :text],
			40 => ['Timescales', :text],
			41 => ['Resources', :text],
			42 => ['Lead Officer', :text],
			43 => ['Actions', :text],
			44 => ['Timescales', :text],
			45 => ['Resources', :text],
			46 => ['Lead Officer', :text],
			47 => ['Actions', :text],
			48 => ['Timescales', :text],
			49 => ['Resources', :text],
			50 => ['Lead Officer', :text]
		}
	}
	overall_questions = {
		:purpose =>{
			2 => ["What is the target outcome of the Function", :text],
                        5 =>['Service users', :impact_amount],
                        6 =>['Staff employed by the council', :impact_amount],
			7 =>['Staff of supplier organisations', :impact_amount],
			8 =>['Staff of partner organisations', :impact_amount],
			9 =>['Employees of businesses', :impact_amount]
		},
		:performance => { 
			1 =>['How would you rate the current performance of the Function?', :rating], 
			2 =>['Has this performance been validated?', :yes_no_notsure],
			3 =>['Please note the validation regime:', :string],
			4 =>['Are there any performance issues which might have implications for different individuals within the equality group?', :yes_no_notsure],
			5 =>['Please note any such performance issues:', :text]
		},
		:confidence_information => {
			1 => ['Are there any gaps in the information about the Function?', :yes_no_notsure],
			2 => ['Are there plans to collect additional information?', :yes_no_notsure],
			3 => ['If there are plans to collect more information, what are the timescales?', :timescales],
			4 => ['Are there any others ways by which performance could be assessed?', :yes_no_notsure],
			5 => ['Please note any other performance measures:', :text]
		}
	}
	unless strand == :overall then
		return questions[section][question]
	else
		return overall_questions[section][question]
	end
end
  
end