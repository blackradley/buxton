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
    @activity = activity
    
    questions = Question.find_all_by_activity_id(@activity.id, :include => [:comment, :note]).map{|q| [q, q.comment, q.note]}
    @activity_questions = {}
    questions.each do |question, comment, note|
      @activity_questions[question.name] = [question, comment, note]
    end
    
    @table_data = {:v_padding => 5, :header => table_header}
    @header_data = {:v_padding => 5}
    methods_to_call =  [:page_numbers, :unapproved_logo_on_first_page, :footer, :header, :body, :intro, :purpose, :strand_tables,
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
      # @pdf.image( "#{Rails.root}/public/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      @pdf.text "<b>Birmingham City Council</b>", :justification => :center, :font_size => 22
      @pdf.text " ", :justification => :center, :font_size => 10
      @pdf.text "<c:uline><b>Birmingham City Council EA Toolkit Assessment Report</b></c:uline>", :justification => :center, :font_size => 14
      @pdf.text " ", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
    return @pdf
  end
  
  def build_body
    table = []
    table << ['<b>Activity</b>', @activity.name.titlecase]
    table << ["<b>Directorate </b>", @activity.directorate.name.titlecase]
    
    if @activity.activity_status.to_i > 0 && @activity.activity_type.to_i > 0 then
      table << ["<b>Type</b>", "#{@activity.activity_status_name.titlecase} #{@activity.activity_type_name.titlecase}"]
    else
      table << ['<b>Type</b>', 'Insufficient questions have been answered to determine the type of this activity.']
    end
    table << ["<b>Reference Number</b>", "#{@activity.ref_no}"]
    table << ["<b>Activity Manager</b>", @activity.completer.email]
    table << ["<b>Date Approved</b>", @activity.approved_on.to_s] if @activity.approved?
    table << ["<b>Approver</b>", @activity.approver.email.to_s] if @activity.approver
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
    @pdf.text "For relevant equality strands this provides a score between 1 (lowest) to 5 (highest) showing the level of priority, with reference to equalities, the activity has for the organisation.", :left => 40
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
    if @activity.activity_status.to_i > 0 && @activity.activity_type.to_i > 0
      activity_type = "#{@activity.activity_status_name.titlecase} #{@activity.activity_type_name.titlecase}"
      activity_type = (@activity.activity_status_name.titlecase == "Existing") ? "an #{activity_type}" : "a #{activity_type}"
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
    target_q = @activity.questions.find_by_name("purpose_overall_2").label.to_s
    target_a = @activity.questions.find_by_name("purpose_overall_2").response.to_s
    target = [[target_q, target_a]]
    comments = get_comments_and_notes(:purpose_overall_2)
    target += comments  unless comments.blank?
    cell_formats = [[{:shading => SHADE_COLOUR}, nil]]
    comments.size.times {cell_formats << nil}
    @pdf = generate_table(@pdf, target, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10)
    @pdf.text " "
    target_q = @activity.questions.find_by_name("purpose_overall_11").label.to_s
    target_a =['Not answered', 'Yes', 'No', 'Not sure'][@activity.questions.find_by_name("purpose_overall_11").response.to_i]
    target = [[target_q, target_a]]
    comments = get_comments_and_notes(:purpose_overall_11)
    target += comments  unless comments.blank?
    cell_formats = [[{:shading => SHADE_COLOUR}, nil]]
    comments.size.times {cell_formats << nil}
    @pdf = generate_table(@pdf, target, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10)
    if @activity.questions.find_by_name("purpose_overall_11").response == 1
      @pdf.text " "
      target_q = @activity.questions.find_by_name("purpose_overall_12").label.to_s
      target_a = ['Not answered', 'Yes', 'No', 'Not sure'][@activity.questions.find_by_name("purpose_overall_12").response.to_i]
      target = [[target_q, target_a]]
      comments = get_comments_and_notes(:purpose_overall_12)
      target += comments  unless comments.blank?
      cell_formats = [[{:shading => SHADE_COLOUR}, nil]]
      comments.size.times {cell_formats << nil}
      @pdf = generate_table(@pdf, target, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10)
    end
    strategies = []
    @activity.activity_strategies.each do |activity_strategy|
      strategies += [activity_strategy, ['Not answered', 'Yes', 'No'][activity_strategy.strategy_response]]
    end

    unless strategies.blank? do
      table_heading = Proc.new do |document|
        document.text " "
        document.text "<b>For each strategy, please decide whether it is going to be significantly aided by the Function.</b>", :font_size => 10
        document.text " "
        document
      end
     table = []
      strategies.each do |strategy, answer|
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
      @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10, :title_lines => 4, :table_title =>table_heading)
    end
    end
    table_heading = Proc.new do |document|
      document.text " "
      document.text "<b>2.2  <c:uline>Individuals affected by the policy</b></c:uline>", :font_size => 12
      document.text " "
      document
    end
    impact_quns = []
    impact_answers = []
    (5..9).each do |i|
      impact_quns << ["purpose_overall_#{i}".to_sym, @activity.questions.find_by_name("purpose_overall_#{i}").label.to_s]
      impact_answers << (@activity.questions.find_by_name("purpose_overall_#{i}").response.to_i == 1 ? "Yes" : "No")
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
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10, :title_lines => 4, :table_title =>table_heading)
    @pdf
  end
    
  # def build_rankings
  #   @pdf.start_new_page
  #   border_gap = @page_width/@activity.strands.size
  #   borders = []
  #   @pdf.text(" ")
  #   @pdf.text("<b>3.  <c:uline>Relevant Equality Strands</b></c:uline>", :font_size => 12)
  #   @pdf.text(" ")
  #   @pdf.text "The Policy has been identified as being relevant to the following equality strands:", :font_size => 10
  #   @pdf.text(" ")
  #   ranking_table_data = Array.new
  #   impact_table_data = Array.new
  #   2.times do
  #     ranking_table_data << []
  #     impact_table_data << []
  #   end
  #   @activity.strands.each do |strand|
  #     @pdf.text("<C:bullet />  #{strand_display(strand).titlecase}", :left => 20)
  #     borders << border_gap + (borders.last || 0)
  #     ranking_table_data[0] << "<b>#{strand_display(strand).titlecase}</b>"
  #     ranking_table_data[1] << @activity.priority_ranking(strand).to_s
  #     impact_table_data[0] << "<b>#{strand_display(strand).titlecase}</b>"
  #     impact_table_data[1] << @activity.impact_wording(strand).to_s.titlecase
  #   end
  #   @pdf.text " "
  #   @pdf.text "This does not imply that the Policy is completely irrelevant to the other dimensions of equality: merely that its main impact is potentially in these areas and that a proportionate response should focus attention here."
  #   @pdf.text " "
  #   @pdf.text "<c:uline><b>Rankings</b></c:uline>"
  #   @pdf.text " "
  #   @pdf.text "<b>Priority</b> - ranked from 1 lowest priority to 5 highest priority"
  #   @pdf.text " "
  #   specific_data = {:borders => borders, :header_args => [[ranking_table_data.delete_at(0)], @header_data.clone.merge(:borders => borders, :shading => SHADE_COLOUR)]}
  #   @pdf = generate_table(@pdf, ranking_table_data, @table_data.clone.merge(specific_data))  unless borders.empty?
  #   
  #   @pdf.text " "
  #   @pdf.text "<b>Impact</b> - ranked high, medium or low"
  #   @pdf.text " "
  #   
  #   specific_data = {:borders => borders, :header_args => [[impact_table_data.delete_at(0)], @header_data.clone.merge(:borders => borders)]}
  #   @pdf = generate_table(@pdf, impact_table_data, @table_data.clone.merge(specific_data))  unless borders.empty?
  # 
  #   @pdf.text(" ")
  #   @pdf.text "The following sections look at the results for each of these strands in more detail."
  #   @pdf.text " "
  #   @pdf
  # end
  
  def build_strand_tables
    section_index = 1
    Activity.strands.each do |strand|
      build_differential_impact(strand, section_index)
      if @activity.send("#{strand}_relevant")
        heading_proc  = lambda do |document|
          document.text "<b>3.#{section_index}.2  <c:uline>#{strand_display(strand).titlecase} - Impact</b></c:uline>", :font_size => 12
          document.text ' '
          document
        end
        build_section("impact", strand, heading_proc)
        heading_proc = lambda do |document|
          document.text "<b>3.#{section_index}.3  <c:uline>#{strand_display(strand).titlecase} - Consultation</b></c:uline>", :font_size => 12
          document.text ' '
          document
        end
        build_section("consultation", strand, heading_proc)
        heading_proc = lambda do |document|
          document.text "<b>3.#{section_index}.4  <c:uline>#{strand_display(strand).titlecase} - Additional Work</b></c:uline>", :font_size => 12
          document.text ' '
          document
        end
        build_section("additional_work", strand, heading_proc)
        @pdf.start_new_page
      end
      section_index += 1
    end
    @pdf
  end
  
  def build_differential_impact(strand,  section_index)
    table = []
    cell_formats = []
    question = @activity.questions.find_by_name("purpose_#{strand}_3")
    question_text = "Might the Function affect #{question.label.sub(',', ' in different ways')}"
    comments = get_comments_and_notes(question.name)
    return if comments.blank? && !@activity.send("#{strand}_relevant")
    table << [question_text, question.display_response]
    cell_formats << [{:shading => SHADE_COLOUR}, nil]
    table += comments  unless comments.blank?
    comments.size.times {cell_formats << nil}
    return if table.blank?
    heading_proc = lambda do |document|
      document.text "<b>3.#{section_index}  <c:uline>#{strand_display(strand).titlecase}</b></c:uline>", :font_size => 12
      document.text ' '
      document.text "<b>3.#{section_index}.1  <c:uline>#{strand_display(strand).titlecase} - Differential Impact</b></c:uline>", :font_size => 12
      document.text ' '
      document
    end
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :font_size => 10, :cell_format => cell_formats, :title_lines => 4, :table_title =>heading_proc)
    @pdf.text " "
  end

  def build_section(section, strand, heading_proc)
    table_data = []
    borders = [300, @page_width]
    information = @activity.questions.where(:strand => strand, :section => section, :needed => true).order(:name)
    information.sort!{|a, b| a.name.slice(/\d+\z/) <=> b.name.slice(/\d+\z/)}
    cell_formats = []
    information.each do |question|
      question_text = question.label
      response = question.display_response
      table_data << [question_text, response]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      comments = get_comments_and_notes(question.name)
      table_data += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
    @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats, :title_lines => 4, :table_title =>heading_proc)
    @pdf.text(" ")
    @pdf
  end
  
  def build_equality_objectives
    @pdf.text("<c:uline><b>6. Equality Objectives</b></c:uline>")
    @pdf.text(" ")
    @pdf.text("The assessment has identified that #{@activity.name.titlecase} has a role in the following Equality Objectives")
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
      row <<  @activity.questions.find_by_name("additional_work_#{strand}_4").display_response
      row_cell_format << nil
      if strand.to_s == 'gender' then
        row << " "
        row_cell_format << {:shading => SHADE_COLOUR}
      else
        row << @activity.questions.find_by_name("additional_work_#{strand}_6").display_response
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
      @pdf.text("The assessment has identified that #{@activity.name.titlecase} has a role in the following Equality Objectives that are specific to the Disability Equality Strand:")
      @pdf.text(" ")
      table = []
      heading_information =  [["<b>Equality Strand</b>", "<b>Take Account of Disabilities Even if it Means Treating More Favourably</b>",  "<b>Encourage Participation by Disabled People</b>", "<b>Promote Positive Attitudes to Disabled People</b>"]]
      row = []
      row << 'Disability'
      row << @activity.questions.find_by_name("additional_work_disability_7").display_response
      row << @activity.questions.find_by_name("additional_work_disability_8").display_response
      row << @activity.questions.find_by_name("additional_work_disability_9").display_response
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
      impact_enabled =  @activity.questions.find_by_name("impact_#{strand}_9").response == 1
      consultation_enabled =  @activity.questions.find_by_name("consultation_#{strand}_7").response == 1
      strand_issues = @activity.issues.find_all_by_strand(strand)
      strand_issues.reject!{|issue| issue.section == 'impact'} unless impact_enabled
      strand_issues.reject!{|issue| issue.section == 'consultation'} unless consultation_enabled
      
      next if strand_issues.blank?
      heading_proc = lambda do |document|
        document.text "<b>5.#{index}  #{strand_display(strand).titlecase}</b>", :font_size => 12
        document.text ' ', :font_size => 10
        document
      end
      title_lines = 4
      index += 1
      strand_issues.each do |issue|
        table = []
        table << ["Issue", issue.description]
        table << ["Action", issue.actions.to_s]
        table << ["Resources", issue.resources.to_s]
        table << ["Timescales", issue.timescales.to_s]
        table << ["Lead Officer", issue.lead_officer.to_s]
        @pdf = generate_table(@pdf, table, :borders => borders, :font_size => 10, :col_format => [{:shading => SHADE_COLOUR}, nil], :title_lines => title_lines, :table_title =>heading_proc)
        heading_proc = nil
        title_lines = nil
        @pdf.text ' '
      end
    end
    @pdf
  end

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
