#
# $URL$
# $Rev$
# $Author$
# $Date$
#
# Copyright (c) 2008 Black Radley Systems Limited. All rights reserved.
#
require 'rubygems'
require 'pdf/writer'

class ActivityPDFGenerator

  def initialize(activity)
    @pdf = PDF::Writer.new
    methods_to_call =  [:page_numbers, :unapproved_logo_on_first_page, :footer, :header, :body, :rankings,
     :purpose, :impact, :consultation, :additional_work, :equality_objectives, :review_date, :action_plan, :appendices]
    methods_to_call.each do |operation|
      @pdf = self.send("build_#{operation.to_s}", @pdf, activity)
    end
    @pdf.stop_page_numbering(true)
  end

  def pdf
    @pdf
  end
  def build_page_numbers(pdf, activity)
    pdf.start_page_numbering(pdf.absolute_left_margin,
      pdf.absolute_bottom_margin - (pdf.font_height(12) * 1.01) - 5,
      12,
      :left)
    pdf
  end
  def build_unapproved_logo_on_first_page(pdf, activity)
      pdf.unapproved_status = (activity.approved) ? '' : 'UNAPPROVED'
      #The page numbers are started at the top, so that they will always hit the first page, but they appear at the bottom
      #This creates the grey Unapproved background.
      colour = 'Gainsboro'
      pdf.save_state
      pdf.fill_color Color::RGB.const_get(colour)
      pdf.add_text(pdf.margin_x_middle-150, pdf.margin_y_middle-150, pdf.unapproved_status, 72, 45)
      pdf.restore_state
    return pdf
  end
  def build_header(pdf, activity)
      pdf.fill_color Color::RGB.const_get('Black')
      pdf.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      pdf.text "<b>#{activity.organisation.name}</b>", :justification => :center, :font_size => 18
      pdf.text "Impact Equality#{153.chr} Activity Report", :justification => :center, :font_size => 12
      pdf.text "", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
      pdf.text " "
    return pdf
  end
  def build_body(pdf, activity)
    table = []
    table << ['<b>Activity</b>', activity.name.to_s]
    table << ["<b>#{ot('directorate', activity).titleize}</b>", activity.directorate.name.to_s]
    unless activity.projects.blank? then
      table << ["<b>#{ot('project', activity).titleize}</b>", activity.projects.first.name.to_s]
      (activity.projects - [activity.projects.first]).each do |project|
        table << ["", project.name.to_s]
      end
    end
    if activity.existing_proposed.to_i > 0 && activity.function_policy.to_i > 0 then
      table << ["<b>Type</b>", "#{activity.existing_proposed_name.titleize} #{activity.function_policy?.titleize}"]
    else
      table << ['<b>Type</b>', 'Insufficient questions have been answered to determine the type of this activity.']
    end
    table << ["<b>Activity Manager's Email</b>", activity.activity_manager.email]
    table << ["<b>Date Approved</b>", activity.approved_on.to_s] if activity.approved?
    table << ["<b>Approver</b>", activity.activity_approver.email.to_s] if activity.activity_approver
    pdf = generate_table(pdf, table, {:borders => [150, 540]})
    pdf
  end
  def build_rankings(pdf, activity)
    pdf.text(" ")
    pdf.text("<c:uline><b>1.  Rankings</b></c:uline>")
    pdf.text(" ")
    pdf.text("<b>1.1 Priority</b>")
    pdf.text(" ")
    length = pdf.absolute_right_margin - pdf.absolute_left_margin
    border_gap = length/(activity.strands.size + 1)
    borders = [border_gap]
    ranking_table_data = []
    ranking_table_data[0] = ["<b>Scores(1 to 5)</b>"]
    ranking_table_data[1] = ['Scores - 1 lowest to 5 highest']
    impact_table_data = []
    impact_table_data[0] = ["<b>Equality strand</b>"]
    impact_table_data[1] = ['Impact Rating']
    activity.strands.each do |strand|
      borders << border_gap + borders.last
      ranking_table_data[0] << "<b>#{strand.titleize}</b>"
      ranking_table_data[1] << activity.priority_ranking(strand).to_s
      impact_table_data[0] << "<b>#{strand.titleize}</b>"
      impact_table_data[1] << activity.impact_wording(strand).to_s.titleize
    end
    pdf = generate_table(pdf, ranking_table_data, :borders => borders)
    pdf.text(" ")
    pdf.text("<b>1.2 Impact</b>")
    pdf.text(" ")
    pdf = generate_table(pdf, impact_table_data, :borders => borders)
    pdf
  end
  def build_purpose(pdf, activity)
    pdf.text(" ")
    pdf.text("<c:uline><b>2.  Purpose </b></c:uline>")
    types = [:organisation, :directorate, :project]
    strategies = [[], [],[]]
    activity.activity_strategies.each do |activity_strategy|
      case activity_strategy.strategy.class.name
        when "OrganisationStrategy"
          strategies[0] << activity_strategy.strategy.name if activity_strategy.strategy_response == 1
        when "DirectorateStrategy"
          strategies[1] << activity_strategy.strategy.name if activity_strategy.strategy_response == 1
        when "ProjectStrategy"
          strategies[2] << activity_strategy.strategy.name if activity_strategy.strategy_response == 1
      end
    end
    strategies.each_with_index do |child_strategies, index|
     type = types[index]      
      unless child_strategies.size == 0 then
        pdf.text("The Activity assists in delivering the following strategic objectives on the #{type.to_s.titleize} level:")
        child_strategies.each do |strategy|
          pdf.text("<C:bullet/> #{strategy}", :left => 20)
        end
      else
        pdf.text("The Activity does not assist in delivering any strategic objectives on on the #{type.to_s.titleize} level.")
      end
    end    
    pdf.text(" ")
    impact_quns = []
    (5..9).each do |i|
      impact_quns << "<C:bullet/>#{activity.question_wording_lookup(:purpose, :overall, i)[0].to_s}" if activity.send("purpose_overall_#{i}") == 1
    end
    if impact_quns.size > 0 then
      pdf.text("The Activity has an impact on the following groups: ")
      impact_quns.each do |question|
        pdf.text(question, :left => 20)
      end
    else
      pdf.text("The Activity has no impact on any relevant groups.")
    end
    pdf.text(" ")
    good_impact_questions = Activity.get_question_names('purpose', nil, 3).map{|question| [question, activity.send(question)]}
    good_impact_questions.reject!{|question, response| response.to_i <= 1}
    unless good_impact_questions.size == 0 then
      pdf.text("The Activity has a potential positive differential impact on the following equality groups:")
      good_impact_questions.each do |question, response|
        strand = Activity.question_separation(question)[1]
        pdf.text("<C:bullet/>#{strand.to_s.titleize}", :left => 20)
      end
    else
      pdf.text("The Activity has a potential positive differential impact on no equality groups.")
    end
    pdf.text(" ")
    bad_impact_questions = Activity.get_question_names('purpose', nil, 4).map{|question| [question, activity.send(question)]}
    bad_impact_questions.reject!{|question, response| response.to_i <= 1}
    unless bad_impact_questions.size == 0 then
      pdf.text("The Activity has a potential negative differential impact on the following equality groups:")
      bad_impact_questions.each do |question, response|
        strand = Activity.question_separation(question)[1]
        pdf.text("<C:bullet/>#{strand.to_s.titleize}", :left => 20)
      end
    else
      pdf.text("The Activity has a potential negative differential impact on no equality groups.")
    end
    pdf.text(" ")
    pdf
  end

  def build_impact(pdf, activity)
    pdf.text("<c:uline><b>3.  Impact </b></c:uline>")
    pdf.text(" ")
    collected_information = Activity.get_question_names('impact', nil, 3).map{|question| [question, activity.send(question)]}
    collected_information.reject! do |question, response|
      not_needed = response.to_s.strip.size == 0
      not_needed = not_needed || activity.send(question.to_s.gsub('3','2').to_sym) != 1
      not_needed
    end
    planned_information = Activity.get_question_names('impact', nil, 5).map{|question| [question, activity.send(question)]}
    planned_information.reject! do |question, response|
      not_needed = response.to_s.strip.size == 0
      not_needed = not_needed || activity.send(question.to_s.gsub('5','4').to_sym) != 1
      not_needed
    end
    width = (pdf.absolute_right_margin - pdf.absolute_left_margin)
    border_gap = width/(4)
    borders = [border_gap]
    3.times do |i|
      borders << borders.last.to_i + border_gap
    end
    table = []
    table << ["<b>Equality Strand</b>", "<b>Current assessment of the impact of the Activity</b>", "<b>Information to support</b>", "<b>Planned Information to support</b>"]
    activity.strands.each do |strand|
      row = []
      row << strand.titleize
      row << activity.hashes['choices'][2][activity.send("impact_#{strand}_1".to_sym).to_i]
      row << collected_information.select{|question, response| question.to_s.include?(strand)}.flatten[1].to_s
      row << planned_information.select{|question, response| question.to_s.include?(strand)}.flatten[1].to_s
      table << row
    end
    pdf = generate_table(pdf, table, :borders => borders)
    pdf.text(" ")
    pdf
  end

  def build_consultation(pdf, activity)
    pdf.text("<c:uline><b>4.  Consultation </b></c:uline>")
    pdf.text(" ")
    pdf.text("<b>4.1 Groups</b>")
    pdf.text(" ")
    pdf.text("The table below shows the equality strands for consultations with representative groups have taken place, the details of those consultations and any planned consultations.")
    pdf.text(" ")
    borders = [150, 300, 540]
    collected_information = Activity.get_question_names('consultation', nil, 3).map{|question| [question, activity.send(question)]}
    collected_information.reject! do |question, response|
      not_needed = response.to_s.strip.size == 0
      not_needed = not_needed || activity.send(question.to_s.gsub('3','1').to_sym) != 1
      not_needed
    end
    table = []
    table << ["<b>Equality Strand</b>", "<b>Consulted</b>", "<b>Consultation Details</b>"]
    activity.strands.each do |strand|
      row = []
      row << strand.titleize
      row << activity.hashes['choices'][3][activity.send("consultation_#{strand}_1").to_i].to_s
      row << collected_information.select{|question, response| question.to_s.include?(strand)}.flatten[1].to_s
      table << row
    end
    pdf = generate_table(pdf, table, :borders => borders)
    pdf.text(" ")
    pdf.text("<b>4.2 Stakeholders</b>")
    pdf.text(" ")
    pdf.text("The table below shows the equality strands for which stakeholders have been consulted, the details of those consultations and any planned consultations..")
    pdf.text(" ")
    collected_information = Activity.get_question_names('consultation', nil, 6).map{|question| [question, activity.send(question)]}
    collected_information.reject! do |question, response|
      not_needed = response.to_s.strip.size == 0
      not_needed = not_needed || activity.send(question.to_s.gsub('6','4').to_sym) != 1
      not_needed
    end
    table = []
    table << ["<b>Equality Strand</b>", "<b>Consulted</b>", "<b>Consultation Details</b>"]
    activity.strands.each do |strand|
      row = []
      row << strand.titleize
      row << activity.hashes['choices'][3][activity.send("consultation_#{strand}_4").to_i].to_s
      row << collected_information.select{|question, response| question.to_s.include?(strand)}.flatten[1].to_s
      table << row
    end
    pdf = generate_table(pdf, table, :borders => borders)
    pdf.text(" ")
    pdf
  end

  def build_additional_work(pdf, activity)
    pdf.text("<c:uline><b>5.  Additional Work</b></c:uline>")
    pdf.text(" ")
    width = (pdf.absolute_right_margin - pdf.absolute_left_margin)
    borders = [150, 300, 540]
    collected_information = Activity.get_question_names('additional_work', nil, 1).map{|question| [question, activity.send(question)]}
    collected_information.reject! do |question, response|
      not_needed = response.to_s.strip.size == 0
      not_needed = not_needed || activity.send(question.to_s.gsub('2','1').to_sym) != 1
      not_needed
    end
    table = []
    table << ["<b>Equality Strand</b>", "<b>Additional Work Required</b>", "<b>Nature of Work required</b>"]
    activity.strands.each do |strand|
      row = []
      row << strand.titleize
      row << activity.hashes['choices'][3][activity.send("additional_work_#{strand}_1").to_i].to_s
      row << collected_information.select{|question, response| question.to_s.include?(strand)}.flatten[1].to_s
      table << row
    end
    pdf = generate_table(pdf, table, :borders => borders)
    pdf.text(" ")
    pdf
  end

  def build_equality_objectives(pdf, activity)
    pdf.text("<c:uline><b>6. Equality Objectives </b></c:uline>")
    pdf.text(" ")
    pdf.text("The assessment has identified that the Activity has a role in the following Equality Objectives")
    pdf.text(" ")
    width = (pdf.absolute_right_margin - pdf.absolute_left_margin)
    border_gap = width/(3)
    borders = [border_gap]
    2.times do |i|
      borders << borders.last.to_i + border_gap
    end
    table = []
    table << ["<b>Equality Strand</b>", "<b>Eliminating discrimination & harassment</b>", "<b>Promote good relations between different groups</b>"]
    activity.strands.each do |strand|
      row = []
      row << strand.titleize
      row << activity.hashes['choices'][3][activity.send("additional_work_#{strand}_4").to_i].to_s
      if strand.to_s == 'gender' then
        row << 'N/A'
      else
        row << activity.hashes['choices'][3][activity.send("additional_work_#{strand}_6").to_i].to_s
      end
      table << row
    end
    pdf = generate_table(pdf, table, :borders => borders)
    border_gap = width/(4)
    borders = [border_gap]
    3.times do |i|
      borders << borders.last.to_i + border_gap
    end
    pdf.text(" ")
    if activity.disability_relevant then
      pdf.text("The assessment has identified that the Activity has a role in the following Equality Objectives that are specific to the Disability Equality Strand:")
      pdf.text(" ")
      table = []
      table << ["<b>Equality strand</b>", "<b>Take account of disabilities even if it means treating more favourably</b>", "<b>Promote positive attitudes to disabled people</b>", "<b>Encourage participation by disabled people</b>"]
      row = []
      row << 'Disability'
      row << activity.hashes['choices'][3][activity.send("additional_work_disability_7").to_i].to_s
      row << activity.hashes['choices'][3][activity.send("additional_work_disability_8").to_i].to_s
      row << activity.hashes['choices'][3][activity.send("additional_work_disability_9").to_i].to_s
      table << row
      pdf = generate_table(pdf, table, :borders => borders)
      pdf.text(" ")
    end
    pdf
  end
  def build_review_date(pdf, activity)
    pdf.text("<c:uline><b>7.  Review Date</b></c:uline>")
    pdf.text(" ")
    unless activity.review_on.to_s.strip.size == 0 then
      pdf.text(activity.review_on.to_s)
      pdf.text " "
    else
      pdf.text("No review date has been decided on yet.")
      pdf.text " "
    end
    pdf
  end
  def build_action_plan(pdf, activity)
    pdf.text("<c:uline><b>8.  Action Plan</b></c:uline>")
    pdf.text(" ")
    if activity.issues.size == 0 then
      pdf.text("There are no relevant issues, so no action plans are currently required.")
      return pdf
    end
    width = (pdf.absolute_right_margin - pdf.absolute_left_margin)
    border_gap = width/(5)
    borders = [border_gap]
    4.times do |i|
      borders << borders.last.to_i + border_gap
    end
    issues = []
    activity.strands.each do |strand|
      impact_enabled =  (activity.send("impact_#{strand}_9") == 1)
      consultation_enabled =  (activity.send("consultation_#{strand}_7") == 1)
      strand_issues = activity.issues.find_all_by_strand(strand)
      strand_issues.reject!{|issue| issue.section == 'impact'} unless impact_enabled
      strand_issues.reject!{|issue| issue.section == 'consultation'} unless consultation_enabled
      issues << strand_issues
    end
    issues.flatten!
    table = []
    table << ["<b>Issue</b>", "<b>Action</b>", "<b>Resources</b>", "<b>Timescales</b>", "<b>Lead Officer</b>"]
    issues.each do |issue|
      row = []
      row << issue.description.titleize
      row << issue.actions.to_s
      row << issue.resources.to_s
      row << issue.timescales.to_s
      row << issue.lead_officer.to_s
      table << row
    end
    pdf = generate_table(pdf, table, :borders => borders)
    pdf
  end

  def build_appendices(pdf, activity)
    global_comments = false
    has_comments = false
    #check if there are any questions with comments in the overall section
    Activity.get_question_names(nil, :overall).each do |question_symbol|
      question = activity.questions.find_by_name(question_symbol.to_s)
      if question.comment && !(question.comment.contents.blank?) then
        has_comments = true
        global_comments = true
      end
    end
    #Check if there are any activity strategies with comments
    strategy_comments = false
    activity.activity_strategies.each do |act_strat|
      if act_strat.comment && !(act_strat.comment.contents.blank?) then
        strategy_comments = true
        global_comments = true
      end
    end
    strand_needed = {}
    activity.strands.each do |strand|
      strand_needed[strand] = false
      Activity.get_question_names(strand).each do |question_name|
        question = activity.questions.find_by_name(question_name.to_s)
        if question.comment && !(question.comment.contents.blank?) && question.needed then
          strand_needed[strand] = true
          global_comments = true
        end
      end
    end
    purpose_strand_needed = strand_needed.clone
    activity.strands(true).each do |strand|
      Activity.get_question_names('purpose', strand).each do |question_name|
        question = activity.questions.find_by_name(question_name.to_s)
        if question.comment && !(question.comment.contents.blank?) && question.needed then
          purpose_strand_needed[strand] = true
          global_comments = true
        end        
      end
    end
    if global_comments then
      pdf.start_new_page
      pdf.text "<c:uline><b>Appendices</b></c:uline>", :justification => :center, :font_size => 14
      pdf.text " "
      #display comments if there are any for the overall section
      if has_comments then
        global_comments = true
        pdf.text "<b>Complete assessment summary of the responses pertaining to all individuals participating</b>", :font_size => 12
        pdf.text " "
        question_list = []
        question_list << ["<b>Question</b>", "<b>Additional Comments</b>"]
        Activity.get_question_names(nil, :overall).each do |question|
          number = question.to_s.gsub(/\D/, "").to_i
          question_details = activity.question_wording_lookup('purpose', 'overall', number)
          prelude = "Does the #{activity.function_policy?} have an impact on " if (5..9).include? number
          label = "#{prelude}#{prelude.to_s.length > 0? question_details[0].downcase : question_details[0]}#{"?" if (5..9).include? number}"
          question_object = activity.questions.find_by_name(question.to_s)
          next unless (question_object && question_object.needed)
          comment = question_object.comment.contents.to_s if question_object.comment
          comment = comment.to_s
          question_list << [label, comment.to_s] unless comment.blank?
        end
        borders = [150, 300, 540]
        if question_list.size > 1 then
          pdf = generate_table(pdf, question_list, {:borders => borders})
        else
          pdf.text "<i>There are no questions with comments for this section</i>", :font_size => 10
        end
        pdf.text " "
      end
      question_list = []
      # display all strategy comments if there are any
      if strategy_comments then
        pdf.text "<b>Comments on any Strategy responses</b>"
        pdf.text " "
        question_list << ['<b>Strategy Name</b>', '<b>Additional Comments</b>']
        activity.activity_strategies.each do |activity_strategy|
          comment = activity_strategy.comment
          comment = comment.contents unless comment.nil?
          question_list << [activity_strategy.strategy.name, comment] unless comment.blank?
        end
        borders = [150, 300, 540]
        if question_list.size > 1 then
          pdf = generate_table(pdf, question_list, {:borders => borders})
        else
          pdf.text "<i>There are no questions with comments for this section</i>", :font_size => 10
        end
        pdf.text " "
      end
      activity.strands(true).each do |strand|
        if strand_needed[strand] || purpose_strand_needed[strand] then
          global_comments = true
          pdf.text " "
          pdf.text "<b>Complete assessment summary of the responses pertaining to #{activity.hashes['wordings'][strand]}</b>", :font_size => 12
          pdf.text " ", :font_size => 10
          (activity.sections - [:action_planning]).each_with_index do |section, index|
            next if !(strand_needed[strand]) && purpose_strand_needed[strand] && (section != :purpose) 
            pdf.text "<b><c:uline>#{index + 1}. #{section.to_s.titleize}</c:uline></b>"
            pdf.text " "
            question_list = []
            question_list << ["<b>Question</b>", "<b>Additional Comments</b>"]
            Activity.get_question_names(section, strand).each do |question|
              number = question.to_s.gsub(section.to_s, "").gsub(strand.to_s, "").gsub("_", "").to_i
              question_details = activity.question_wording_lookup(section, strand, number)
              question_object = activity.questions.find_by_name(question.to_s)
              next unless (question_object && question_object.needed)
              comment = question_object.comment.contents.to_s if question_object.comment
              question_text = question_details[0]
              if section == :purpose then
                question_text = activity.header(:purpose_overall_3).gsub("members of the following groups", question_text) if number == 3
                question_text = activity.header(:purpose_overall_4).gsub("members of the following groups", question_text) if number == 4
              end
              question_list << [question_text, comment] unless comment.blank?
            end
            borders = [150, 300, 540]
            unless question_list.size == 1 then
              pdf = generate_table(pdf, question_list, {:borders => borders})
            else
              pdf.text "<i>There are no questions with comments for this section</i>"
            end
            pdf.text " "
          end
        end
      end
    end
    pdf
  end

  def build_footer(pdf, activity)
      pdf.open_object do |footer|
        pdf.save_state
        pdf.stroke_color! Color::RGB::Black
        pdf.stroke_style! pdf.class::StrokeStyle::DEFAULT
        font_size = 12
        text = "Report Produced: #{Time.now}"
        y = pdf.absolute_bottom_margin - (pdf.font_height(font_size) * 1.01) - 5
        width = pdf.text_width(text, font_size)
        margin = pdf.absolute_right_margin
        pdf.add_text(margin - width, y, text, font_size)
        left_margin = pdf.absolute_left_margin
        right_margin = pdf.absolute_right_margin
        y = pdf.absolute_bottom_margin - 5
        pdf.line(left_margin, y, right_margin, y).stroke
        pdf.restore_state
        pdf.close_object
        pdf.add_object(footer, :all_pages)
      end
    return pdf
  end

  private
  #Custom implementation on SimpleTable. Creates a table in 0.08 seconds as opposed to simpletables 0.7 by redoing some time consuming
  #procedures involved in working out page wraps and initializing objects as opposed to using arrays.
  #arguments to table_data is :offset => The offset of the table relative to it's alignment. :aligment => aligns the table
  #:show lines => :all shows all lines, :borders shows only the borders of the table, :none shows no lines.
  #:borders => sets the borders of the table (for example [0, 100, 200, 300] sets the horizontal
  #borders up at those intervals. A row will autosize to the correct height. A gotcha is that if you specify an offset, it takes it from the left
  # of the page instead of from the left boundary. To be fixed
  #Simple table is still enabled, so if you need functionality that isn't here, then use that.
  def generate_table(pdf, table, table_data = @table_data)
    x_pos = table_data[:offset]
    borders = table_data[:borders]
    show_lines = table_data[:show_lines].nil? ? :all : table_data[:show_lines]
    table_data[:text_alignment] = :left unless table_data[:text_alignment]
    init_pos = x_pos||pdf.absolute_left_margin
    init_pos = pdf.absolute_x_middle - borders.last/2 + x_pos.to_i  if table_data[:alignment] == :center
    init_pos = pdf.absolute_right_margin - borders.last + x_pos.to_i  if table_data[:alignment] == :right
    new_x_pos = borders.last + 2 + init_pos
    top_of_table = pdf.y
    table.each_with_index do |row, row_index|
      lines = 1
      row.each_with_index do |cell, index|
        if index == 0 then
          width = borders[index]
        else
          width = borders[index] - borders[index - 1]
        end
        line_count = cell.size*((150.0/27)*(pdf.font_size/10.0))/width + 1 #Approximation of a width for characters
        lines = line_count if line_count > lines
      end
      if pdf.y < (lines+1).to_i*pdf.font_height + pdf.absolute_bottom_margin then
        pdf.line(init_pos, top_of_table, init_pos, pdf.y).stroke if show_lines && row.id != table.first.id
        pdf.start_new_page
        pdf.line(init_pos, pdf.y, new_x_pos - 2, pdf.y).stroke if (show_lines == :all || show_lines == :borders)
        top_of_table = pdf.y
      end
      pdf.line(init_pos, pdf.y, new_x_pos - 2, pdf.y).stroke if (show_lines == :all || show_lines == :borders) && (row_index == 0)
      borders_to_pass = borders.clone
      table_data_to_pass = table_data.clone
      if row.size != borders.size then
        borders_to_pass.pop while row.size < borders_to_pass.size
        borders_to_pass.pop
        borders_to_pass.push(borders.last)
        table_data_to_pass[:borders] = borders_to_pass
      end
      pdf = add_row(pdf, row, table_data_to_pass, init_pos, show_lines)
      pdf.line(init_pos, pdf.y, borders.last + init_pos, pdf.y) if show_lines == :borders && (row_index == (table.size - 1))
    end
    pdf.line(init_pos, top_of_table, init_pos, pdf.y).stroke if (show_lines == :all || show_lines == :borders)
    pdf
  end

  def add_row(pdf, row, table_data, x_pos = nil, lines = :all)
    top = pdf.y - pdf.font_height
    borders = table_data[:borders]
    pdf.y -= pdf.font_height
    max_height = 0
    x_pos = x_pos || pdf.absolute_left_margin
    init_pos = x_pos
    x_pos += 2
    row.each_with_index do |cell, index|
      if index == 0 then
        width = borders[index]
      else
        width = borders[index] - borders[index - 1]
      end
      if table_data[:text_alignment] == :right then
        x_pos -= 4
      end
      overflow = pdf.add_text_wrap(x_pos, pdf.y, width - 2, cell.to_s, 10, table_data[:text_alignment])
      current_height = 1
      while overflow.length > 0
        pdf.y -= pdf.font_height
        overflow = pdf.add_text_wrap(x_pos, pdf.y, width - 2, overflow, 10, table_data[:text_alignment])
        current_height += 1
      end
      max_height = current_height if current_height > max_height
      x_pos = borders[index] + init_pos + 5
      pdf.y = top
    end
    max_height = (max_height)*pdf.font_height
    pdf.y -= max_height
    if lines != :none then
      x_pos = borders.last + init_pos
      pdf.line(init_pos, pdf.y, x_pos, pdf.y).stroke if lines == :all
      borders.each do |border|
        pdf.line(border + init_pos, top + pdf.font_height, border + init_pos, top - max_height).stroke
      end
    end
    pdf
  end
  def ot(term, activity)
    assoc_term = Terminology.find_by_term(term)
    terminology = activity.organisation.organisation_terminologies.find_by_terminology_id(assoc_term.id)
    terminology ? terminology.value : term
  end
end
