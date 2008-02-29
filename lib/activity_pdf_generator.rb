require 'rubygems'
require 'pdf/writer'

class ActivityPDFGenerator

  def initialize(activity)
    @pdf = PDF::Writer.new
    methods_to_call =  [:page_numbers, :unapproved_logo_on_first_page, :footer, :header, :body, :rankings,
     :purpose, :impact, :consultation, :additional_work, :equality_objectives, :review_date, :action_plan]
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
      pdf.unapproved_status = case activity.approved
        when 0
         "UNAPPROVED"
        when 1
         ""
      end
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
    table << ["<b>#{activity.organisation.directorate_string}</b>", activity.directorate.name.to_s]
    table << ["<b>Type</b>", "#{activity.existing_proposed_name.titleize} #{activity.function_policy?.titleize}"]
    table << ["<b>Activity Manager's Email</b>", activity.activity_manager.email]
    table << ["<b>Date Approved</b>", activity.approved_on.to_s] if activity.approved > 0
    table << ["<b>Approved By</b>", activity.approver.to_s] if activity.approved > 0
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
    strategies = [[],[],[]]
    activity.activity_strategies.each do |activity_strategy|
      case activity_strategy.strategy_response
        when 0
          strategies[0] << activity_strategy.strategy.name
        when 1
          strategies[1] << activity_strategy.strategy.name
        when 2
          strategies[2] << activity_strategy.strategy.name
      end
    end
    unless strategies[1].size == 0 then
      pdf.text("The Activity assists in delivering the following strategic objectives:")
      strategies[1].each do |strategy|
        pdf.text("<C:bullet/> #{strategy}", :left => 20)
      end
    else
      pdf.text("The Activity does not assist in delivering any strategic objectives.")
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
    good_impact_questions.reject!{|question, response| response <= 1}
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
    bad_impact_questions.reject!{|question, response| response <= 1}
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
    border_gap = width/(4)
    borders = [border_gap]
    3.times do |i|
      borders << borders.last.to_i + border_gap
    end  
    table = []
    table << ["<b>Equality Strand</b>", "<b>Eliminating discrimination & harassment</b>", "<b>Promoting equality of opportunity</b>", "<b>Promote good relations between different groups</b>"]
    activity.strands.each do |strand|
      row = []
      row << strand.titleize
      row << activity.hashes['choices'][3][activity.send("additional_work_#{strand}_4").to_i].to_s
      row << activity.hashes['choices'][3][activity.send("additional_work_#{strand}_5").to_i].to_s
      if strand.to_s == 'gender' then
        row << 'N/A'
      else
        row << activity.hashes['choices'][3][activity.send("additional_work_#{strand}_6").to_i].to_s
      end
      table << row
    end     
    pdf = generate_table(pdf, table, :borders => borders)
    pdf.text(" ")
    pdf.text("The assessment has identified that the Activity has a role in the following Equality Objectives that are specific to the Disability Equality Strand:")
    pdf.text(" ")
    table = []
    table << ["<b>Equality strand</b>", "<b>Take account of disabilities even if it means treating more favourably</b>", "<b>Promote positive attitudes to disabled people</b>", "<b>Encourage participation by disabled people</b>"]
    row = []
    row << 'Disability'
    row << activity.hashes['choices'][3][activity.send("additional_work_disability_7")].to_s  
    row << activity.hashes['choices'][3][activity.send("additional_work_disability_8")].to_s  
    row << activity.hashes['choices'][3][activity.send("additional_work_disability_9")].to_s  
    table << row
    pdf = generate_table(pdf, table, :borders => borders)
    pdf.text(" ")
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

  def build_footer(pdf, activity)
      pdf.open_object do |footer|
        pdf.save_state
        pdf.stroke_color! Color::RGB::Black
        pdf.stroke_style! pdf.class::StrokeStyle::DEFAULT
        font_size = 12
        text = "Report Produced: #{Time.now.gmtime}"
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

  private  #Custom implementation on SimpleTable. Creates a table in 0.08 seconds as opposed to simpletables 0.7.
  def generate_table(pdf, table, table_data = @table_data)
    x_pos = table_data[:offset]
    borders = table_data[:borders]
    show_lines = table_data[:show_lines]||true
    init_pos = x_pos||pdf.absolute_left_margin
    init_pos = pdf.absolute_x_middle - borders.last/2 + x_pos.to_i  if table_data[:alignment] == :center
    init_pos = pdf.absolute_right_margin - borders.last + x_pos.to_i  if table_data[:alignment] == :right
    new_x_pos = borders.last + 2 + init_pos
    top_of_table = pdf.y
    table.each do |row|
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
        pdf.line(init_pos, top_of_table, init_pos, pdf.y).stroke if show_lines && row != table.first
        pdf.start_new_page
        pdf.line(init_pos, pdf.y, new_x_pos, pdf.y).stroke if show_lines
        top_of_table = pdf.y
      end
      pdf.line(init_pos, pdf.y, new_x_pos - 2, pdf.y).stroke if show_lines && row == table.first
      borders_to_pass = borders.clone
      table_data_to_pass = table_data.clone
      if row.size != borders.size then
        borders_to_pass.pop while row.size < borders_to_pass.size
        borders_to_pass.pop
        borders_to_pass.push(borders.last)
        table_data_to_pass[:borders] = borders_to_pass 
      end
      pdf = add_row(pdf, row, table_data_to_pass, init_pos, show_lines)
    end
    pdf.line(init_pos, top_of_table, init_pos, pdf.y).stroke if show_lines
    pdf
  end
  
  def add_row(pdf, row, table_data, x_pos = nil, lines = true)
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
      overflow = pdf.add_text_wrap(x_pos, pdf.y, width - 2, cell.to_s, 10)
      current_height = 1
      while overflow.length > 0 
        pdf.y -= pdf.font_height
        overflow = pdf.add_text_wrap(x_pos, pdf.y, width - 2, overflow, 10)
        current_height += 1
      end
      max_height = current_height if current_height > max_height
      x_pos = borders[index] + init_pos + 5
      pdf.y = top
    end
    max_height = (max_height)*pdf.font_height
    pdf.y -= max_height
    if lines then
      x_pos = borders.last + init_pos
      pdf.line(init_pos, pdf.y, x_pos, pdf.y).stroke
      borders.each do |border|
        pdf.line(border + init_pos, top + pdf.font_height, border + init_pos, top - max_height).stroke
      end
    end    
    pdf  
  end
end
