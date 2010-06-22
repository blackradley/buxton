#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require 'pdf/writer'
require 'pdfwriter_extensions'
require 'evensimplertable'
include PDFExtensions

#### TODO: Add notes and comments to respective tables

class ActivityPDFGenerator

  SHADE_COLOUR = Color::RGB::Grey90

  def initialize(activity, type)
    @pdf = PDF::Writer.new(:paper => "A4")
    @page_width = @pdf.absolute_right_margin - @pdf.absolute_left_margin
    @act_name = activity.name.titlecase
    @activity = activity
    
    questions = Question.find_all_by_activity_id(@activity.id, :include => [:comment, :note]).map{|q| [q, q.comment, q.note]}
    @activity_questions = {}
    questions.each do |question, comment, note|
      @activity_questions[question.name] = [question, comment, note]
    end
    
    @table_data = {:v_padding => 5, :header => table_header}
    @header_data = {:v_padding => 5}
    methods_to_call =  [:page_numbers, :unapproved_logo_on_first_page, :footer, :header, :body, :intro, :purpose, :rankings, :strand_tables,
     :review_date, :action_plan]  #:equality_objectives should be included? Not in Iain's latest version?
    @public = (type == 'public')
    methods_to_call.each do |operation|
      @pdf = self.send("build_#{operation.to_s}")
    end
    @pdf.stop_page_numbering(true)
  end

  def pdf
    @pdf
  end
  
  def build_page_numbers
    @pdf.start_page_numbering(@pdf.absolute_left_margin,
      @pdf.absolute_bottom_margin - (@pdf.font_height(12) * 1.01) - 5,
      12,
      :left)
    @pdf
  end
  
  def build_unapproved_logo_on_first_page
      @pdf.unapproved_status = (@activity.approved?) ? '' : 'Work In Progress'
      #The page numbers are started at the top, so that they will always hit the first page, but they appear at the bottom
      #This creates the grey Unapproved background.
      colour = 'Gainsboro'
      @pdf.save_state
      @pdf.fill_color Color::RGB.const_get(colour)
      @pdf.add_text(@pdf.margin_x_middle-150, @pdf.margin_y_middle-150, @pdf.unapproved_status, 72, 45)
      @pdf.restore_state
    return @pdf
  end
  def build_header
      @pdf.fill_color Color::RGB.const_get('Black')
      @pdf.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      @pdf.text "<b>#{@activity.organisation.name.titlecase}</b>", :justification => :center, :font_size => 22
      @pdf.text " ", :justification => :center, :font_size => 10
      @pdf.text "<c:uline><b>Equality Impact Assessment Report</b></c:uline>", :justification => :center, :font_size => 14
      @pdf.text " ", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
    return @pdf
  end
  
  def build_body
    table = []
    table << ['<b>Activity</b>', @act_name]
    table << ["<b>#{ot('directorate', @activity).titlecase}</b>", @activity.directorate.name.titlecase]
    projects = @activity.projects
    unless projects.blank? then
      type = ot('project', @activity).titlecase
      type = type.pluralize if (projects.size > 1)
      project_list = projects.map{|project| project.name.to_s.titlecase}.join("\n")
      table << ["<b>#{type}</b>", project_list]
    end
    
    if @activity.existing_proposed.to_i > 0 && @activity.function_policy.to_i > 0 then
      table << ["<b>Type</b>", "#{@activity.existing_proposed_name.titlecase} #{@activity.function_policy?.titlecase}"]
    else
      table << ['<b>Type</b>', 'Insufficient questions have been answered to determine the type of this activity.']
    end
    table << ["<b>Reference Number</b>", "#{@activity.ref_no}"]
    table << ["<b>Activity Manager</b>", @activity.activity_manager.email]
    table << ["<b>Date Approved</b>", @activity.approved_on.to_s] if @activity.approved?
    table << ["<b>Approver</b>", @activity.activity_approver.email.to_s] if @activity.activity_approver
    @pdf = generate_table(@pdf, table, :borders => [150, 540], :col_format => [{:shading => SHADE_COLOUR}, nil])
    @pdf
  end
  
  def build_intro
    @pdf.text " ", :font_size => 10
    @pdf.text "<c:uline><b>Introduction</b></c:uline>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "The report records the information that has been submitted for this equality impact assessment in the following format."
    @pdf.text " ", :font_size => 10
    @pdf.text "<b>          Overall Purpose</b>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "This section identifies the purpose of the Policy and which types of individual it affects.  It also identifies which equality strands are affected by either a positive or negative differential impact."
    @pdf.text " ", :font_size => 10
    @pdf.text "<b>          Relevant Equality Strands</b>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "For each of the identified relevant equality strands there are three sections which will have been completed."
    @pdf.text "  <C:bullet />  Impact", :left => 20
    @pdf.text "  <C:bullet />  Consultation", :left => 20
    @pdf.text "  <C:bullet />  Additional Work", :left => 20
    @pdf.text " ", :font_size => 10
    @pdf.text "These sections will result in the following rankings:"
    @pdf.text " ", :font_size => 10
    @pdf.text "<b>                    Priority Ranking</b>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "For relevant equality strands this provides a score between 1 (highest) to 5 (lowest) showing the level of priority, with reference to equalities, the activity has for the organisation.", :left => 40
    @pdf.text " ", :font_size => 10
    @pdf.text "<b>                    Impact Ranking</b>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "For relevant equality strands this provides a high, medium or low ranking showing the potential differential impact on individuals within each of the equality groups.", :left => 40
    @pdf.text " ", :font_size => 10
    @pdf.text "If the assessment has raised any issues to be addressed there will also be an action planning section."
    @pdf.text " ", :font_size => 10
    @pdf.text "The following pages record the answers to the assessment questions with optional comments included by the assessor to clarify or explain any of the answers given or relevant issues."
    @pdf.start_new_page
    @pdf.text "<b>1  <c:uline>Activity Type</b></c:uline>", :font_size => 12
    @pdf.text " ", :font_size => 10
    if @activity.existing_proposed.to_i > 0 && @activity.function_policy.to_i > 0
      activity_type = "#{@activity.existing_proposed_name.titlecase} #{@activity.function_policy?.titlecase}"
      activity_type = (@activity.existing_proposed_name.titlecase == "Existing") ? "an #{activity_type}" : "a #{activity_type}"
      @pdf.text "The activity has been identified as #{activity_type}.", :font_size => 10
    else
      @pdf.text "Insufficient questions have been answered to determine the activity type", :font_size => 10
    end
    @pdf.text " ", :font_size => 10
    return @pdf
  end
  
  def get_comments_and_notes(question)
    question_object = @activity_questions[question.to_s]
    comment = question_object[1]
    note = question_object[2]
    question_object = question_object[0]
    return unless (question_object && question_object.needed)
    comment = comment.contents.to_s if comment
    table_data = []
    unless comment.blank?
      table_data << ["<c:uline>Comment</c:uline>\n#{comment}"]
    end
    unless @public
      note = note.contents.to_s if note
      unless note.blank?
        table_data << ["<c:uline>Note</c:uline>\n#{note}"]
      end
    end  
    return table_data
  end
  
  def build_purpose
    @pdf.text " "
    @pdf.text "<b>2  <c:uline>Overall Purpose</b></c:uline>", :font_size => 12
    @pdf.text " "
    @pdf.text "<b>2.1  <c:uline>What the Activity is for</b></c:uline>", :font_size => 12
    @pdf.text " "
    target_q = @activity.question_wording_lookup('purpose', 'overall', 2, true)[0].to_s
    target_a = @activity.send(:purpose_overall_2)
    target = [[target_q, target_a]]
    comments = get_comments_and_notes(:purpose_overall_2)
    target += comments  unless comments.blank?
    cell_formats = [[{:shading => SHADE_COLOUR}, nil]]
    comments.size.times {cell_formats << nil}
    @pdf = generate_table(@pdf, target, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10)
    types = [:organisation, :directorate, :project]
    strategies = [[], [],[]]
    @activity.activity_strategies.each do |activity_strategy|
      case activity_strategy.strategy.class.name
        when "OrganisationStrategy"
          strategies[0] << [activity_strategy, ['Not answered', 'Yes', 'No', 'Not sure'][activity_strategy.strategy_response]]
        when "DirectorateStrategy"
          strategies[1] << [activity_strategy, ['Not answered', 'Yes', 'No', 'Not sure'][activity_strategy.strategy_response]]
        when "ProjectStrategy"
          strategies[2] << [activity_strategy, ['Not answered', 'Yes', 'No', 'Not sure'][activity_strategy.strategy_response]]
      end
    end
    strategies.each_with_index do |child_strategies, index|
      type = types[index]
      table = []
      cell_formats = []
      unless child_strategies.size == 0 then
        @pdf.text " "
        @pdf.text "<b>Does the policy significantly affect the achievement of the following #{type.to_s.titlecase} #{@activity.organisation.term('strategy').titlecase.pluralize}?</b>", :font_size => 10
        @pdf.text " "
        #table << ["The Policy will significantly aid the achievement of the following #{type.to_s.titlecase} #{@activity.organisation.term('strategy').pluralize}:"]
        table = []
        child_strategies.each do |strategy, answer|
          cell_formats << [{:shading => SHADE_COLOUR}, nil]
          table << ["#{strategy.strategy.name.titlecase}", answer]
          unless strategy.comment.blank? || strategy.comment.contents.blank?
            cell_formats << [nil, nil]
            table << ["<c:uline>Comment</c:uline>\n#{strategy.comment.contents.to_s}"]
          end
          unless @public || strategy.note.blank? || strategy.note.contents.blank?
            cell_formats << [nil, nil]
            table << ["<c:uline>Note</c:uline>\n#{strategy.note.contents.to_s}"]
          end
        end
        @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10)
      end  
    end
    @pdf.text " "
    @pdf.text "<b>2.2  <c:uline>Individuals affected by the policy</b></c:uline>", :font_size => 12
    @pdf.text " "
    impact_quns = []
    impact_answers = []
    (5..9).each do |i|
      impact_quns << ["purpose_overall_#{i}".to_sym, @activity.question_wording_lookup(:purpose, :overall, i, true)[0].to_s]
      impact_answers << (@activity.send("purpose_overall_#{i}") == 1 ? "Yes" : "No")
    end
    
    table = []
    cell_formats = []

    impact_quns.each_with_index do |question, i|
      table << ["Will the policy have an impact on #{question[1].downcase}?", impact_answers[i]]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      comments = get_comments_and_notes(question[0])
      table += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
    #:col_format => [nil, {:text_alignment => :center}]
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10)
    @pdf
  end
    
  def build_rankings
    @pdf.start_new_page
    border_gap = @page_width/@activity.strands.size
    borders = []
    @pdf.text(" ")
    @pdf.text("<b>3.  <c:uline>Relevant Equality Strands</b></c:uline>", :font_size => 12)
    @pdf.text(" ")
    @pdf.text "The Policy has been identified as being relevant to the following equality strands:", :font_size => 10
    @pdf.text(" ")
    ranking_table_data = Array.new
    impact_table_data = Array.new
    2.times do
      ranking_table_data << []
      impact_table_data << []
    end
    @activity.strands.each do |strand|
      @pdf.text("<C:bullet />  #{strand_display(strand).titlecase}", :left => 20)
      borders << border_gap + (borders.last || 0)
      ranking_table_data[0] << "<b>#{strand_display(strand).titlecase}</b>"
      ranking_table_data[1] << @activity.priority_ranking(strand).to_s
      impact_table_data[0] << "<b>#{strand_display(strand).titlecase}</b>"
      impact_table_data[1] << @activity.impact_wording(strand).to_s.titlecase
    end
    @pdf.text " "
    @pdf.text "This does not imply that the Policy is completely irrelevant to the other dimensions of equality: merely that its main impact is potentially in these areas and that a proportionate response should focus attention here."
    @pdf.text " "
    @pdf.text "<c:uline><b>Rankings</b></c:uline>"
    @pdf.text " "
    @pdf.text "<b>Priority</b> - ranked from 1 lowest priority to 5 highest priority"
    @pdf.text " "
    specific_data = {:borders => borders, :header_args => [[ranking_table_data.delete_at(0)], @header_data.clone.merge(:borders => borders, :shading => SHADE_COLOUR)]}
    @pdf = generate_table(@pdf, ranking_table_data, @table_data.clone.merge(specific_data))  unless borders.empty?
    
    @pdf.text " "
    @pdf.text "<b>Impact</b> - ranked high, medium or low"
    @pdf.text " "
    
    specific_data = {:borders => borders, :header_args => [[impact_table_data.delete_at(0)], @header_data.clone.merge(:borders => borders)]}
    @pdf = generate_table(@pdf, impact_table_data, @table_data.clone.merge(specific_data))  unless borders.empty?

    @pdf.text(" ")
    @pdf.text "The following sections look at the results for each of these strands in more detail."
    @pdf.text " "
    @pdf
  end
  
  def build_strand_tables
    good_impact_questions = Activity.get_question_names('purpose', nil, 3).map{|question| [question, @activity.send(question)]}
    good_differentials = Hash.new
    good_impact_questions.each do |question, response|
      strand = Activity.question_separation(question)[1]
      section_strand = question.to_s.split('_')
      question_text = @activity.question_wording_lookup(section_strand.first, strand, section_strand.last, true)[0].to_s
      good_differentials[strand] = [question, question_text, @activity.hashes['choices'][1][response.to_i].to_s]
    end
    bad_impact_questions = Activity.get_question_names('purpose', nil, 4).map{|question| [question, @activity.send(question)]}
    bad_differentials = Hash.new
    bad_impact_questions.each do |question, response|
      strand = Activity.question_separation(question)[1]
      section_strand = question.to_s.split('_')
      question_text = @activity.question_wording_lookup(section_strand.first, strand, section_strand.last, true)[0].to_s
      bad_differentials[strand] = [question, question_text, @activity.hashes['choices'][1][response.to_i].to_s]
    end
    
    section_index = 1
    Activity.strands.each do |strand|
      build_differential_impact(strand, good_differentials[strand], bad_differentials[strand], section_index)
      if @activity.send("#{strand}_relevant")
        @pdf.text "<b>3.#{section_index}.2  <c:uline>#{strand_display(strand).titlecase} - Impact</b></c:uline>", :font_size => 12
        @pdf.text ' '
        build_impact(strand)
        @pdf.text "<b>3.#{section_index}.3  <c:uline>#{strand_display(strand).titlecase} - Consultation</b></c:uline>", :font_size => 12
        @pdf.text ' '
        build_consultation(strand)
        @pdf.text "<b>3.#{section_index}.4  <c:uline>#{strand_display(strand).titlecase} - Additional Work</b></c:uline>", :font_size => 12
        @pdf.text ' '
        build_additional_work(strand)
        @pdf.start_new_page
      end
      section_index += 1
    end
    @pdf
  end

  def build_table_data(data_array, choices_elem = nil, col_text = nil)
    table = []
    table_cell_format = []
    @activity.strands.each do |strand|
      row = []
      row_cell_format = []
      row << strand_display(strand).titlecase
      row_cell_format << nil
      unless col_text.nil?
        row << @activity.hashes['choices'][choices_elem][@activity.send(col_text[0] + strand + col_text[1]).to_i].to_s
        row_cell_format << nil
      end
      
      data_array.each do |question, response, format|
        if question.to_s.include?(strand)
          row << response
          row_cell_format << format
        end
      end
      table << row
      table_cell_format << row_cell_format
    end
    return [table, table_cell_format]
  end
  
  def build_differential_impact(strand, good_impact, bad_impact, section_index)
#    good_impact_questions.reject!{|question, response| response.to_i <= 1}
    table = []
    cell_formats = []
    [good_impact, bad_impact].each_with_index do |impact, index|
      question_text = "Might the #{@activity.function_policy?.titlecase} #{index == 0 ? 'benefit' : 'disadvantage'} #{impact[1].sub(',', ' in different ways')}"
      comments = get_comments_and_notes(impact[0])
      unless @activity.send("#{strand}_relevant")
        next if comments.blank?
      end
      table << [question_text, impact[2]]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      table += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
    return if table.blank?
    @pdf.text "<b>3.#{section_index}  <c:uline>#{strand_display(strand).titlecase}</b></c:uline>", :font_size => 12
    @pdf.text ' '
    @pdf.text "<b>3.#{section_index}.1  <c:uline>#{strand_display(strand).titlecase} - Differential Impact</b></c:uline>", :font_size => 12
    @pdf.text ' '
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :font_size => 10, :cell_format => cell_formats)
    @pdf.text " "
    # unless good_impact_questions.size == 0 then
    #   @pdf.text("#{@act_name} has a potential positive differential impact on the following equality groups:")
    #   good_impact_questions.each do |question, response|
    #     strand = Activity.question_separation(question)[1]
    #     @pdf.text("<C:bullet/>#{strand.to_s.titlecase}", :left => 20)
    #   end
    # else
    #   @pdf.text("#{@act_name} has a potential positive differential impact on no equality groups.")
    # end
    # 
    # @pdf.text(" ")
    # bad_impact_questions = Activity.get_question_names('purpose', nil, 4).map{|question| [question, @activity.send(question)]}
    # bad_impact_questions.reject!{|question, response| response.to_i <= 1}
    # 
    # unless bad_impact_questions.size == 0 then
    #   @pdf.text("#{@act_name} has a potential negative differential impact on the following equality groups:")
    #   bad_impact_questions.each do |question, response|
    #     strand = Activity.question_separation(question)[1]
    #     @pdf.text("<C:bullet/>#{strand.to_s.titlecase}", :left => 20)
    #   end
    # else
    #   @pdf.text("#{@act_name} has a potential negative differential impact on no equality groups.")
    # end
    # @pdf.text(" ")
  end

  def build_impact(strand)
#    @pdf.text("<c:uline><b>3.  Impact</b></c:uline>")
#    @pdf.text(" ")
    # collected_information = Activity.get_question_names('impact', nil, 3).map{|question| [question, @activity.send(question)]}
    # collected_information = remove_unneeded(collected_information)
    # planned_information = Activity.get_question_names('impact', nil, 5).map{|question| [question, @activity.send(question)]}
    # planned_information = remove_unneeded(planned_information)
#    heading_information = [["<b>Equality Strand</b>", "<b>Current Assessment of the Impact of #{@act_name}</b>", "<b>Information to Support</b>", "<b>Planned Information to Support</b>"]]
#    table_info = build_table_data(collected_information + planned_information, 2, ["impact_","_1"])

    table_data = []
    borders = [300, @page_width]
    information = Activity.get_question_names('impact', strand).map{|question| [question, @activity.send(question)]}
    information = remove_unneeded(information)
    information.sort!{|a, b| a[0].to_s.slice(/\d+\z/) <=> b[0].to_s.slice(/\d+\z/)}
    cell_formats = []
    information.each do |question, answer|
      q_no = question.to_s.slice(/\d+\z/)
      question_text = @activity.question_wording_lookup('impact', strand, q_no, true)[0].to_s
      response = if choices = @activity.hashes['questions']['impact'][q_no.to_i]['choices']
                   @activity.hashes['choices'][choices][@activity.send(question).to_i].to_s
                 else
                   answer
                 end
      table_data << [question_text, response]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      comments = get_comments_and_notes(question)
      table_data += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
# "How would you assess the potential impact of the Policy in meeting the particular needs of "
# "Do you have current evidence to support this assessment ?"
# "The evidence to support this assessment is"
# "If there is evidence from more than one source does it present a consistent view of the potential impact of the Policy on meeting the particular needs of "
# "Are there any potential issues about the way in which the Policy meets the particular needs of"
    
#    specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
#    specific_data[:cell_format] = table_info[1]
    @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats)
    @pdf.text(" ")
    @pdf
  end

  def build_consultation(strand)
    # @pdf.text("<c:uline><b>4.  Consultation</b></c:uline>")
    # @pdf.text(" ")
    # @pdf.text("<b>4.1 Groups</b>")
    # @pdf.text(" ")
    # @pdf.text("The table below shows the equality strands for consultations with representative groups have taken place, the details of those consultations and any planned consultations.")
    # @pdf.text(" ")
    borders = [300, @page_width]
    information = Activity.get_question_names('consultation', strand).map{|question| [question, @activity.send(question)]}
    information = remove_unneeded(information)
    information.sort!{|a, b| a[0].to_s.slice(/\d+\z/) <=> b[0].to_s.slice(/\d+\z/)}
    table_data = []
    cell_formats = []
    information.each do |question, answer|
      q_no = question.to_s.slice(/\d+\z/)
      question_text = @activity.question_wording_lookup('consultation', strand, q_no, true)[0].to_s
      response = if choices = @activity.hashes['questions']['consultation'][q_no.to_i]['choices']
                   @activity.hashes['choices'][choices][@activity.send(question).to_i].to_s
                 else
                   answer
                 end
      table_data << [question_text, response]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      comments = get_comments_and_notes(question)
      table_data += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
    @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats)
    
    # collected_information = Activity.get_question_names('consultation', nil, 3).map{|question| [question, @activity.send(question)]}
    # collected_information = remove_unneeded(collected_information)
    # heading_information = [["<b>Equality Strand</b>", "<b>Consulted</b>", "<b>Consultation Details</b>"]]
    # table_info = build_table_data(collected_information, 3, ["consultation_", "_1"])
    # specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
    # specific_data[:cell_format] = table_info[1]
    # @pdf = generate_table(@pdf, table_info[0], @table_data.clone.merge(specific_data))
    # @pdf.text(" ")
    # @pdf.text("<b>4.2 Stakeholders</b>")
    # @pdf.text(" ")
    # @pdf.text("The table below shows the equality strands for which stakeholders have been consulted, the details of those consultations and any planned consultations..")
    # @pdf.text(" ")
    # collected_information = Activity.get_question_names('consultation', nil, 6).map{|question| [question, @activity.send(question)]}
    # collected_information = remove_unneeded(collected_information)
    # heading_information = [["<b>Equality Strand</b>", "<b>Consulted</b>", "<b>Consultation Details</b>"]]
    # table_info = build_table_data(collected_information, 3, ["consultation_", "_4"])
    # specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
    # specific_data[:cell_format] = table_info[1]
    # @pdf = generate_table(@pdf, table_info[0], @table_data.clone.merge(specific_data))
    @pdf.text(" ")
    @pdf
  end

  def build_additional_work(strand)
    # @pdf.text("<c:uline><b>5.  Additional Work</b></c:uline>")
    # @pdf.text(" ")
    borders = [300, @page_width]
    information = Activity.get_question_names('additional_work', strand).map{|question| [question, @activity.send(question)]}
    information = remove_unneeded(information)
    # collected_information = Activity.get_question_names('additional_work', nil, 2).map{|question| [question, @activity.send(question)]}
    # collected_information = remove_unneeded(collected_information)
    # heading_information = [["<b>Equality Strand</b>", "<b>Additional Work Required</b>", "<b>Nature of Work Required</b>"]]
    # table_info = build_table_data(collected_information, 3, ["additional_work_", "_1"])
    # specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
    # specific_data[:cell_format] = table_info[1]
    # @pdf = generate_table(@pdf, table_info[0], @table_data.clone.merge(specific_data))
    information.sort!{|a, b| a[0].to_s.slice(/\d+\z/) <=> b[0].to_s.slice(/\d+\z/)}
    table_data = []
    cell_formats = []
    information.each do |question, answer|
      q_no = question.to_s.slice(/\d+\z/)
      question_text = @activity.question_wording_lookup('additional_work', strand, q_no, true)[0].to_s
      response = if choices = @activity.hashes['questions']['additional_work'][q_no.to_i]['choices']
                   @activity.hashes['choices'][choices][@activity.send(question).to_i].to_s
                 else
                   answer
                 end
      table_data << [question_text, response]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      comments = get_comments_and_notes(question)
      table_data += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
    @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats)
    @pdf.text(" ")
    @pdf
  end

  def build_equality_objectives
    @pdf.text("<c:uline><b>6. Equality Objectives</b></c:uline>")
    @pdf.text(" ")
    @pdf.text("The assessment has identified that #{@act_name} has a role in the following Equality Objectives")
    @pdf.text(" ")
    border_gap = @page_width/(3)
    borders = [border_gap]
    2.times do |i|
      borders << borders.last.to_i + border_gap
    end
    table = []
    table_cell_format = []
    heading_information =  [["<b>Equality Strand</b>", "<b>Eliminating Discrimination & Harassment</b>", "<b>Promote Good Relations Between Different Groups</b>"]]
    @activity.strands.each do |strand|
      row = []
      row_cell_format = []
      row << strand_display(strand).titlecase
      row_cell_format << nil
      row << @activity.hashes['choices'][3][@activity.send("additional_work_#{strand}_4").to_i].to_s
      row_cell_format << nil
      if strand.to_s == 'gender' then
        row << " "
        row_cell_format << {:shading => SHADE_COLOUR}
      else
        row << @activity.hashes['choices'][3][@activity.send("additional_work_#{strand}_6").to_i].to_s
        row_cell_format << nil
      end
      table << row
      table_cell_format << row_cell_format
    end
    specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
    specific_data[:cell_format] = table_cell_format
    @pdf = generate_table(@pdf, table, @table_data.clone.merge(specific_data))
    border_gap = @page_width/(4)
    borders = [border_gap]
    3.times do |i|
      borders << borders.last.to_i + border_gap
    end
    @pdf.text(" ")
    if @activity.disability_relevant then
      @pdf.text("The assessment has identified that #{@act_name} has a role in the following Equality Objectives that are specific to the Disability Equality Strand:")
      @pdf.text(" ")
      table = []
      heading_information =  [["<b>Equality Strand</b>", "<b>Take Account of Disabilities Even if it Means Treating More Favourably</b>",  "<b>Encourage Participation by Disabled People</b>", "<b>Promote Positive Attitudes to Disabled People</b>"]]
      row = []
      row << 'Disability'
      row << @activity.hashes['choices'][3][@activity.send("additional_work_disability_7").to_i].to_s
      row << @activity.hashes['choices'][3][@activity.send("additional_work_disability_8").to_i].to_s
      row << @activity.hashes['choices'][3][@activity.send("additional_work_disability_9").to_i].to_s
      table << row
      specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
      @pdf = generate_table(@pdf, table, @table_data.clone.merge(specific_data))
      @pdf.text(" ")
    end
    @pdf
  end
  
  def build_review_date
    @pdf.text("<b>4  <c:uline>Review Date</b></c:uline>", :font_size => 12)
    @pdf.text(" ")
    unless @activity.review_on.to_s.strip.size == 0 then
      @pdf.text(@activity.review_on.to_s, :font_size => 10)
      @pdf.text " "
    else
      @pdf.text("No review date has been decided on yet.", :font_size => 10)
      @pdf.text " "
    end
    @pdf
  end
  def build_action_plan
    @pdf.text("<b>5  <c:uline>Action Plan</b></c:uline>", :font_size => 12)
    @pdf.text(" ")
    if @activity.issues.size == 0 then
      @pdf.text("There are no relevant issues, so no action plans are currently required.", :font_size => 10)
      return @pdf
    end
    borders = [100, @page_width]
    issues = []
    index = 1
    @activity.strands.each do |strand|
      impact_enabled =  (@activity.send("impact_#{strand}_9") == 1)
      consultation_enabled =  (@activity.send("consultation_#{strand}_7") == 1)
      strand_issues = @activity.issues.find_all_by_strand(strand)
      strand_issues.reject!{|issue| issue.section == 'impact'} unless impact_enabled
      strand_issues.reject!{|issue| issue.section == 'consultation'} unless consultation_enabled
      
      next if strand_issues.blank?
      @pdf.text "<b>5.#{index}  #{strand_display(strand).titlecase}</b>", :font_size => 12
      index += 1
      @pdf.text ' ', :font_size => 10
      strand_issues.each do |issue|
        table = []
        table << ["Issue", issue.description]
        table << ["Action", issue.actions.to_s]
        table << ["Resources", issue.resources.to_s]
        table << ["Timescales", issue.timescales.to_s]
        table << ["Lead Officer", issue.lead_officer.to_s]
        @pdf = generate_table(@pdf, table, :borders => borders, :font_size => 10, :col_format => [{:shading => SHADE_COLOUR}, nil])
        @pdf.text ' '
      end
    end
    # table = []
    # heading_information = [["<b>Issue</b>", "<b>Action</b>", "<b>Resources</b>", "<b>Timescales</b>", "<b>Lead Officer</b>"]]
    # issues.each do |issue|
    #   row = []
    #   row << issue.description.titlecase
    #   row << issue.actions.to_s
    #   row << issue.resources.to_s
    #   row << issue.timescales.to_s
    #   row << issue.lead_officer.to_s
    #   table << row
    # end
    # @pdf = generate_table(@pdf, table, :borders => borders)
    @pdf
  end

  # def build_comments
  #   global_comments = false
  #   has_comments = false
  #   #check if there are any questions with comments in the overall section
  #   Activity.get_question_names(nil, :overall).each do |question_symbol|
  #     question = @activity.questions.find_by_name(question_symbol.to_s)
  #     if question.comment && !(question.comment.contents.blank?) then
  #       has_comments = true
  #       global_comments = true
  #     end
  #   end
  #   #Check if there are any activity strategies with comments
  #   strategy_comments = false
  #   @activity.activity_strategies.each do |act_strat|
  #     if act_strat.comment && !(act_strat.comment.contents.blank?) then
  #       strategy_comments = true
  #       global_comments = true
  #     end
  #   end
  #   strand_needed = {}
  #   @activity.strands.each do |strand|
  #     strand_needed[strand] = false
  #     Activity.get_question_names(strand).each do |question_name|
  #       question = @activity.questions.find_by_name(question_name.to_s)
  #       if question.comment && !(question.comment.contents.blank?) && question.needed then
  #         strand_needed[strand] = true
  #         global_comments = true
  #       end
  #     end
  #   end
  #   purpose_strand_needed = strand_needed.clone
  #   @activity.strands(true).each do |strand|
  #     Activity.get_question_names('purpose', strand).each do |question_name|
  #       question = @activity.questions.find_by_name(question_name.to_s)
  #       if question.comment && !(question.comment.contents.blank?) && question.needed then
  #         purpose_strand_needed[strand] = true
  #         global_comments = true
  #       end        
  #     end
  #   end
  #   if global_comments then
  #     @pdf.start_new_page
  #     @pdf.text "<c:uline><b>Appendices</b></c:uline>", :justification => :center, :font_size => 14
  #     @pdf.text " "
  #     #display comments if there are any for the overall section
  #     if has_comments then
  #       global_comments = true
  #       @pdf.text "<b>Complete Assessment Summary of the Responses Pertaining to all Individuals Participating</b>", :font_size => 12
  #       @pdf.text " "
  #       question_list = []
  #       heading_information = [["<b>Question</b>", "<b>Additional Comments</b>"]]
  #       Activity.get_question_names(nil, :overall).each do |question|
  #         number = question.to_s.gsub(/\D/, "").to_i
  #         question_details = @activity.question_wording_lookup('purpose', 'overall', number)
  #         prelude = "Does the #{@activity.function_policy?} have an impact on " if (5..9).include? number
  #         label = "#{prelude}#{prelude.to_s.length > 0? question_details[0].downcase : question_details[0]}#{"?" if (5..9).include? number}"
  #         question_object = @activity.questions.find_by_name(question.to_s)
  #         next unless (question_object && question_object.needed)
  #         comment = question_object.comment.contents.to_s if question_object.comment
  #         comment = comment.to_s
  #         question_list << [label, comment.to_s] unless comment.blank?
  #       end
  #       borders = [150, 300, 540]
  #       if question_list.size > 0 then
  #         specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
  #         @pdf = generate_table(@pdf, question_list, @table_data.clone.merge(specific_data))
  #       else
  #         @pdf.text "<i>There are no questions with comments for this section</i>", :font_size => 10
  #       end
  #       @pdf.text " "
  #     end
  #     question_list = []
  #     # display all strategy comments if there are any
  #     if strategy_comments then
  #       @pdf.text "<b>Comments on any Strategy Responses</b>"
  #       @pdf.text " "
  #       heading_information = [['<b>Strategy Name</b>', '<b>Additional Comments</b>']]
  #       @activity.activity_strategies.each do |activity_strategy|
  #         comment = activity_strategy.comment
  #         comment = comment.contents unless comment.nil?
  #         question_list << [activity_strategy.strategy.name, comment] unless comment.blank?
  #       end
  #       borders = [150, 300, 540]
  #       if question_list.size > 0 then
  #         specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
  #         @pdf = generate_table(@pdf, question_list, @table_data.clone.merge(specific_data))
  #       else
  #         @pdf.text "<i>There are no questions with comments for this section</i>", :font_size => 10
  #       end
  #       @pdf.text " "
  #     end
  #     @activity.strands(true).each do |strand|
  #       if strand_needed[strand] || purpose_strand_needed[strand] then
  #         global_comments = true
  #         @pdf.text " "
  #         @pdf.text "<b>Complete Assessment Summary of the Responses Pertaining to #{@activity.hashes['wordings'][strand].titlecase}</b>", :font_size => 12
  #         @pdf.text " ", :font_size => 10
  #         (@activity.sections - [:action_planning]).each_with_index do |section, index|
  #           next if !(strand_needed[strand]) && purpose_strand_needed[strand] && (section != :purpose)
  #           question_list = []
  #           heading_information = [["<b>Question</b>", "<b>Additional Comments</b>"]]
  #           Activity.get_question_names(section, strand).each do |question|
  #             number = question.to_s.gsub(section.to_s, "").gsub(strand.to_s, "").gsub("_", "").to_i
  #             question_details = @activity.question_wording_lookup(section, strand, number)
  #             question_object = @activity.questions.find_by_name(question.to_s)
  #             next unless (question_object && question_object.needed)
  #             comment = question_object.comment.contents.to_s if question_object.comment
  #             question_text = question_details[0]
  #             if section == :purpose then
  #               question_text = @activity.header(:purpose_overall_3).gsub(":", " " + question_text.downcase) if number == 3
  #               question_text = @activity.header(:purpose_overall_4).gsub(":", " " +question_text.downcase) if number == 4
  #             end
  #             question_list << [question_text, comment] unless comment.blank?
  #           end
  #           borders = [150, 300, 540]
  #           unless question_list.size == 0 then
  #             @pdf.text "<c:uline><b>#{section.to_s.titlecase}</b></c:uline>"
  #             @pdf.text " "
  #             specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
  #             @pdf = generate_table(@pdf, question_list, @table_data.clone.merge(specific_data))
  #           end
  #           @pdf.text " "
  #         end
  #       end
  #     end
  #   end
  #   @pdf
  # end
  # 
  # def build_notes
  #   global_notes = false
  #   has_notes = false
  #   #check if there are any questions with notes in the overall section
  #   Activity.get_question_names(nil, :overall).each do |question_symbol|
  #     question = @activity.questions.find_by_name(question_symbol.to_s)
  #     if question.note && !(question.note.contents.blank?) then
  #       has_notes = true
  #       global_notes = true
  #     end
  #   end
  #   #Check if there are any activity strategies with notes
  #   strategy_notes = false
  #   @activity.activity_strategies.each do |act_strat|
  #     if act_strat.note && !(act_strat.note.contents.blank?) then
  #       strategy_notes = true
  #       global_notes = true
  #     end
  #   end
  #   strand_needed = {}
  #   @activity.strands.each do |strand|
  #     strand_needed[strand] = false
  #     Activity.get_question_names(strand).each do |question_name|
  #       question = @activity.questions.find_by_name(question_name.to_s)
  #       if question.note && !(question.note.contents.blank?) && question.needed then
  #         strand_needed[strand] = true
  #         global_notes = true
  #       end
  #     end
  #   end
  #   purpose_strand_needed = strand_needed.clone
  #   @activity.strands(true).each do |strand|
  #     Activity.get_question_names('purpose', strand).each do |question_name|
  #       question = @activity.questions.find_by_name(question_name.to_s)
  #       if question.note && !(question.note.contents.blank?) && question.needed then
  #         purpose_strand_needed[strand] = true
  #         global_notes = true
  #       end        
  #     end
  #   end
  #   if global_notes then
  #     @pdf.start_new_page
  #     #display notes if there are any for the overall section
  #     if has_notes then
  #       global_notes = true
  #       @pdf.text "<b>Complete Assessment Summary of the Notes on the Responses Pertaining to all Individuals Participating</b>", :font_size => 12
  #       @pdf.text " "
  #       question_list = []
  #       heading_information = [["<b>Question</b>", "<b>Additional Notes</b>"]]
  #       Activity.get_question_names(nil, :overall).each do |question|
  #         number = question.to_s.gsub(/\D/, "").to_i
  #         question_details = @activity.question_wording_lookup('purpose', 'overall', number)
  #         prelude = "Does the #{@activity.function_policy?} have an impact on " if (5..9).include? number
  #         label = "#{prelude}#{prelude.to_s.length > 0? question_details[0].downcase : question_details[0]}#{"?" if (5..9).include? number}"
  #         question_object = @activity.questions.find_by_name(question.to_s)
  #         next unless (question_object && question_object.needed)
  #         note = question_object.note.contents.to_s if question_object.note
  #         note = note.to_s
  #         question_list << [label, note.to_s] unless note.blank?
  #       end
  #       borders = [150, 300, 540]
  #       if question_list.size > 0 then
  #         specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
  #         @pdf = generate_table(@pdf, question_list, @table_data.clone.merge(specific_data))
  #       else
  #         @pdf.text "<i>There are no questions with notes for this section</i>", :font_size => 10
  #       end
  #       @pdf.text " "
  #     end
  #     question_list = []
  #     # display all strategy notes if there are any
  #     if strategy_notes then
  #       @pdf.text "<b>Notes on any Strategy Responses</b>"
  #       @pdf.text " "
  #       heading_information = [['<b>Strategy Name</b>', '<b>Additional Notes</b>']]
  #       @activity.activity_strategies.each do |activity_strategy|
  #         note = activity_strategy.note
  #         note = note.contents unless note.nil?
  #         question_list << [activity_strategy.strategy.name, note] unless note.blank?
  #       end
  #       borders = [150, 300, 540]
  #       if question_list.size > 0 then
  #         specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
  #         @pdf = generate_table(@pdf, question_list, @table_data.clone.merge(specific_data))
  #       else
  #         @pdf.text "<i>There are no questions with notes for this section</i>", :font_size => 10
  #       end
  #       @pdf.text " "
  #     end
  #     @activity.strands(true).each do |strand|
  #       if strand_needed[strand] || purpose_strand_needed[strand] then
  #         global_notes = true
  #         @pdf.text " "
  #         @pdf.text "<b>Complete Assessment Summary of the Notes on the Responses Pertaining to #{@activity.hashes['wordings'][strand].titlecase}</b>", :font_size => 12
  #         @pdf.text " ", :font_size => 10
  #         (@activity.sections - [:action_planning]).each_with_index do |section, index|
  #           next if !(strand_needed[strand]) && purpose_strand_needed[strand] && (section != :purpose)
  #           question_list = []
  #           heading_information = [["<b>Question</b>", "<b>Additional Notes</b>"]]
  #           Activity.get_question_names(section, strand).each do |question|
  #             number = question.to_s.gsub(section.to_s, "").gsub(strand.to_s, "").gsub("_", "").to_i
  #             question_details = @activity.question_wording_lookup(section, strand, number)
  #             question_object = @activity.questions.find_by_name(question.to_s)
  #             next unless (question_object && question_object.needed)
  #             note = question_object.note.contents.to_s if question_object.note
  #             question_text = question_details[0]
  #             if section == :purpose then
  #               question_text = @activity.header(:purpose_overall_3).gsub(":", " " + question_text.downcase) if number == 3
  #               question_text = @activity.header(:purpose_overall_4).gsub(":", " " +question_text.downcase) if number == 4
  #             end
  #             question_list << [question_text, note] unless note.blank?
  #           end
  #           borders = [150, 300, 540]
  #           unless question_list.size == 0 then
  #             @pdf.text "<c:uline><b>#{section.to_s.titlecase}</b></c:uline>"
  #             @pdf.text " "
  #             specific_data = {:borders => borders, :header_args => [heading_information, @header_data.clone.merge(:borders => borders)]}
  #             @pdf = generate_table(@pdf, question_list, @table_data.clone.merge(specific_data))
  #           end
  #           @pdf.text " "
  #         end
  #       end
  #     end
  #   end
  #   @pdf
  # end

  def build_footer
      @pdf.open_object do |footer|
        @pdf.save_state
        @pdf.stroke_color! Color::RGB::Black
        @pdf.stroke_style! @pdf.class::StrokeStyle::DEFAULT
        font_size = 12
        text = "Report Produced: #{Time.now}"
        y = @pdf.absolute_bottom_margin - (@pdf.font_height(font_size) * 1.01) - 5
        width = @pdf.text_width(text, font_size)
        margin = @pdf.absolute_right_margin
        @pdf.add_text(margin - width, y, text, font_size)
        left_margin = @pdf.absolute_left_margin
        right_margin = @pdf.absolute_right_margin
        y = @pdf.absolute_bottom_margin - 5
        @pdf.line(left_margin, y, right_margin, y).stroke
        @pdf.restore_state
        @pdf.close_object
        @pdf.add_object(footer, :all_pages)
      end
    return @pdf
  end

  private
  
  # FIX: This should not be defined again. Use just one ot() method.
  def ot(term, activity)
    assoc_term = Terminology.find_by_term(term)
    terminology = activity.organisation.organisation_terminologies.find_by_terminology_id(assoc_term.id)
    terminology ? terminology.value : term
  end
  
  def remove_unneeded(question_array)
    return question_array.select do |question, response|
      (@activity_questions[question.to_s] && @activity_questions[question.to_s][0].check_needed)
    end
  end
  
  # def remove_unneeded(question_array)
  #     return question_array.map do |question, response|
  #       if (@activity.questions.find_by_name(question.to_s) && @activity.questions.find_by_name(question.to_s).check_needed) then
  #         [question, response, nil]
  #       else
  #         [question, " ", {:shading => SHADE_COLOUR}]
  #       end
  #     end    
  #   end
  
  def table_header
    Proc.new do |pdf, data, table_data| 
      pdf = generate_table(pdf, data, table_data)
      pdf
    end
  end
  
  def strand_display(strand)
    strand.to_s.downcase == 'faith' ? 'religion or belief' : strand
  end
end
