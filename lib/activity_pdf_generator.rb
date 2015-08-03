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

    questions = Question.includes(:comment, :note).where(activity_id: @activity.id).map{|q| [q, q.comment, q.note]}
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
      @pdf.image( "#{Rails.root}/app/assets/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      @pdf.text "<b>Equality Analysis</b>", :justification => :center, :font_size => 22
      @pdf.text " ", :justification => :center, :font_size => 10
      @pdf.text "<c:uline><b>Birmingham City Council Analysis Report</b></c:uline>", :justification => :center, :font_size => 14
      @pdf.text " ", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
    return @pdf
  end

  def build_body
    table = []
    table << ['<b>EA Name</b>', @activity.name.titlecase]
    table << ["<b>Directorate </b>", @activity.directorate.name.titlecase]
    table << ["<b>Service Area</b>", @activity.service_area.name.titlecase]
    table << ["<b>Type</b>", "#{@activity.activity_status_name.titlecase} #{@activity.activity_type_name.titlecase}"]
    table << ["<b>EA Summary</b>", @activity.summary.to_s]
    table << ["<b>Reference Number</b>", "#{@activity.ref_no}"]
    table << ["<b>Task Group Manager</b>", @activity.completer.email]
    table << ["<b>Task Group #{@activity.helpers.size > 1 ? 'Members' : 'Member'}</b>", @activity.helpers.all.map(&:email).join(', ')]
    table << ["<b>Date Approved</b>", @activity.approved_on.to_s] if @activity.approved?
    table << ["<b>Senior Officer</b>", @activity.approver.email.to_s] if @activity.approver
    table << ["<b>Quality Control Officer</b>", @activity.qc_officer.email.to_s] if @activity.qc_officer
    @pdf = generate_table(@pdf, table, :borders => [150, 540], :col_format => [{:shading => SHADE_COLOUR}, nil])
    @pdf
  end

  def build_intro
    @pdf.text " ", :font_size => 10
    @pdf.text "<c:uline><b>Introduction</b></c:uline>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "The report records the information that has been submitted for this equality analysis in the following format."
    @pdf.text " ", :font_size => 10
    @pdf.text "<b>          Initial Assessment</b>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "This section identifies the purpose of the Policy and which types of individual it affects.  It also identifies which equality strands are affected by either a positive or negative differential impact."
    @pdf.text " ", :font_size => 10
    @pdf.text "<b>          Relevant Protected Characteristics</b>", :font_size => 12
    @pdf.text " ", :font_size => 10
    @pdf.text "For each of the identified relevant protected characteristics there are three sections which will have been completed."
    @pdf.text "  <C:bullet />  Impact", :left => 20
    @pdf.text "  <C:bullet />  Consultation", :left => 20
    @pdf.text "  <C:bullet />  Additional Work", :left => 20
    @pdf.text " ", :font_size => 10
    @pdf.text "If the assessment has raised any issues to be addressed there will also be an action planning section."
    @pdf.text " ", :font_size => 10
    @pdf.text "The following pages record the answers to the assessment questions with optional comments included by the assessor to clarify or explain any of the answers given or relevant issues."
    @pdf.start_new_page
    @pdf.text "<b>1  <c:uline>Activity Type</b></c:uline>", :font_size => 12
    @pdf.text " ", :font_size => 10
    activity_type = "#{@activity.activity_status_name.titlecase} #{@activity.activity_type_name.titlecase}"
    activity_type = (@activity.activity_status_name.titlecase == "Existing") ? "an #{activity_type}" : "a #{activity_type}"
    @pdf.text "The activity has been identified as #{activity_type}.", :font_size => 10
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
    if @activity.previous_activity  && !@activity.approved
      previous_question_data = []
      q = @activity.questions.where(:name => question.to_s).first
      if q.different_comment? && !q.previous.comment.blank?  && !@activity.approved
        previous_question_data << ["<i><c:uline>Previous Comment</c:uline>\n#{q.previous.comment.contents.to_s}</i>"]
      end
      unless @public
        if q.different_note? && !q.previous.note.blank?  && !@activity.approved
          previous_question_data << ["<i><c:uline>Previous Note</c:uline>\n#{q.previous.note.contents.to_s}</i>"]
        end
      end
      table_data += previous_question_data
    end
    return table_data
  end

  def get_comments(question)
    question_object = @activity_questions[question.to_s]
    comment = question_object[1]
    question_object = question_object[0]
    return unless (question_object && question_object.needed)
    comment = comment.contents.to_s if comment
    table_data = []
    unless comment.blank?
      table_data << "<b>Comment:</b>\n#{comment}"
    end
    if @activity.previous_activity  && !@activity.approved
      previous_question_data = []
      q = @activity.questions.where(:name => question.to_s).first
      if q.different_comment? && !q.previous.comment.blank?
        previous_question_data << "<i><b>Previous Comment:</b>\n#{q.previous.comment.contents.to_s}</i>"
      end
      table_data += previous_question_data
    end
    return table_data
  end

  def build_purpose
    @pdf.text " "
    @pdf.text "<b>2  <c:uline>Initial Assessment</b></c:uline>", :font_size => 12
    @pdf.text " "
    @pdf.text "<b>2.1  <c:uline>Purpose and Link to Strategic Themes</b></c:uline>", :font_size => 12
    @pdf.text " "
    target_q = @activity.questions.find_by(name: "purpose_overall_2").label.to_s
    target_a = @activity.questions.find_by(name: "purpose_overall_2").response.to_s
    qn = @activity.questions.find_by(name: "purpose_overall_2")
    target = [[target_q, target_a]]
    target << ["Previously: " + target_q, qn.previous.display_response].map{|a| "<i>#{a}</i>"} if qn.different_answer? && !@activity.approved
    comments = get_comments(:purpose_overall_2)
    target += comments  unless comments.blank?
    cell_formats = [[{:shading => SHADE_COLOUR}, nil]]
      cell_formats << [{:shading => SHADE_COLOUR}, nil] if qn.different_answer?
    comments.size.times {cell_formats << nil}
    @pdf = generate_table(@pdf, target, :borders => [150, 540], :cell_format => cell_formats, :font_size => 10)
    @pdf.text " "
    strategies = []
    @activity.activity_strategies.each do |activity_strategy|
      strategies << [activity_strategy, ['Not answered', 'Yes', 'No'][activity_strategy.strategy_response.to_i]]
    end
    unless strategies.blank?
      table_heading = Proc.new do |document|
        document.text " "
        document.text "<b>For each strategy, please decide whether it is going to be significantly aided by the Function.</b>", :font_size => 10
        document.text " "
        document
      end
      table_heading.call(@pdf)
      table = []
      strategies.each do |strategy, answer|
        next unless strategy.strategy
        cell_formats << [{:shading => SHADE_COLOUR}, nil]
        table << ["#{strategy.strategy.name.titlecase}", answer]
        unless strategy.comment.blank? || strategy.comment.contents.blank?
          @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10, :title_lines => 4)
          table = []
          cell_formats = []
          cell_formats << [nil, nil]
          @pdf.text "<b>Comment:</b>\n#{strategy.comment.contents}"
        end
        # unless @public || strategy.note.blank? || strategy.note.contents.blank?
        #   cell_formats << [nil, nil]
        #   table << ["<c:uline>Note</c:uline>\n#{strategy.note.contents.to_s}"]
        # end
        if strategy.changed_in_previous_ea?  && !@activity.approved
          if strategy.different_comment?
            unless strategy.previous.try(:comment).blank? || strategy.previous.comment.contents.blank?
              @pdf.text ["<i><b>Previous Comment</b>\n#{strategy.previous.comment.contents.to_s}</i>"]
            end
          end
        end
      end
      @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10, :title_lines => 4) unless table.blank?
    end
    table_heading = Proc.new do |document|
      document.text " "
      document.text "<b>2.2  <c:uline>Individuals affected by the policy</b></c:uline>", :font_size => 12
      document.text " "
      document
    end
    impact_quns = []
    impact_answers = []
    [5,6,7].each do |i|
      impact_quns << ["purpose_overall_#{i}".to_sym, @activity.questions.find_by(name: "purpose_overall_#{i}").label.to_s]
      impact_answers << (@activity.questions.find_by(name: "purpose_overall_#{i}").response.to_i == 1 ? "Yes" : "No")
    end

    table = []
    cell_formats = []

    impact_quns.each_with_index do |question, i|
      table << ["Will the policy have an impact on #{question[1].downcase}?", impact_answers[i]]
      cell_formats << [{:shading => SHADE_COLOUR}, nil]
      comments = get_comments(question[0])
      table += comments  unless comments.blank?
      comments.size.times {cell_formats << nil}
    end
    #:col_format => [nil, {:text_alignment => :center}]
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :cell_format => cell_formats, :font_size => 10, :title_lines => 4, :table_title =>table_heading)

    @pdf.text " "
    @pdf.text "<b> 2.3 <c:uline> Relevance Test</b></c:uline> ", :font_size => 12
    @pdf.text " "

    table = []
    table << ['<b>Protected Characteristics</b>', '<b>Relevant</b>']

    @activity.overview_strands.sort{|a,b| strand_display(a[0]) <=> strand_display(b[0]) }.each do |strand_name, strand|
      table << [strand_display(strand).titlecase, @activity.strand_required?(strand) ? 'Yes' : 'No']
    end
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :font_size => 10)

    @pdf.text " "
    @pdf.text "<b> 2.4 <c:uline> Analysis on Initial Assessment</b></c:uline> ", :font_size => 12
    @pdf.text " "
    final_question = @activity.questions.where(:name => "purpose_overall_13").first
    if final_question.changed_in_previous_ea?
      if final_question.different_answer? && !@activity.approved
        @pdf.text "<i> Previously </i>"
        @pdf.text "<i> #{final_question.previous.response} </i>"
      end
    end

    @pdf.text final_question.response, :font_size => 10
    @pdf.text " "
    if final_question.comment
      @pdf.text "<b> Additional Comments </b>"
      if final_question.changed_in_previous_ea? && final_question.different_comment?  && !@activity.approved
        @pdf.text " "
        @pdf.text "<i> Previously: #{final_question.previous_comment.blank? ? 'No previous comment' : final_question.previous_comment}</i>"
      end
      @pdf.text final_question.comment.contents
      @pdf.text " "

    end
    # if final_question.note
    #   @pdf.text "<b> Additional Notes</b>"
    #   if final_question.changed_in_previous_ea? && final_question.different_note?
    #     @pdf.text "<i> Previously: #{final_question.previous_note.blank? ? 'No previous note' : final_question.previous_note} </i>"
    #     @pdf.text " "
    #   end
    #   @pdf.text final_question.note.contents
    #   @pdf.text " "
    # end
    @pdf.text " "
    @pdf.start_new_page
    @pdf
  end

  def build_strand_tables
    section_index = 1
    @activity.strands(true).sort{|a,b| strand_display(a[0]) <=> strand_display(b[0]) }.each do |strand|
      build_differential_impact(strand, section_index) if ( @activity.strand_required?(strand) || get_comments("purpose_#{strand}_3").present? )
      next unless @activity.strand_required?(strand)
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
      section_index += 1
    end
    @pdf.text " "
    @pdf.text "<b> 3#{'.' + section_index.to_s if @activity.strands.size > 0} <c:uline> Concluding Statement on Full Assessment</b></c:uline> ", :font_size => 12
    @pdf.text " "
    final_question = @activity.questions.where(:name => "purpose_overall_14").first
    if final_question.changed_in_previous_ea?
      if final_question.different_answer? && !@activity.approved
        @pdf.text "<i> Previously </i>"
        @pdf.text "<i> #{final_question.previous.response} </i>"
      end
    end
    @pdf.text final_question.response, :font_size => 10
     @pdf.text " "
    if final_question.comment
      @pdf.text "<b> Additional Comments</b>"
      if final_question.changed_in_previous_ea? && final_question.different_comment? && !@activity.approved
        @pdf.text "<i> Previously: #{final_question.previous_comment.blank? ? 'No previous comment' : final_question.previous_comment} </i>"
      end
      @pdf.text final_question.comment.contents
     @pdf.text " "

    end
    # if final_question.note
    #   @pdf.text "<b> Additional Notes </b>"
    #   if final_question.changed_in_previous_ea? && final_question.different_note?
    #     @pdf.text "<i> Previously: #{final_question.previous_note.blank? ? 'No previous note' : final_question.previous_note} </i>"
    #   end
    #   @pdf.text final_question.note.contents
    # end
    @pdf.text " "

    @pdf
  end

  def build_differential_impact(strand,  section_index)
    table = []
    cell_formats = []
    question = @activity.questions.find_by(name: "purpose_#{strand}_3")
    question_text = question.label
    comments = get_comments(question.name)
    # return if comments.blank? && !@activity.send("#{strand}_relevant")
    table << [question_text, question.display_response]
    cell_formats << [{:shading => SHADE_COLOUR}, nil]
    # comments.size.times {cell_formats << nil}
    return if table.blank?
    heading_proc = lambda do |document|
      document.text "<b>3.#{section_index}  <c:uline>#{strand_display(strand).titlecase}</b></c:uline>", :font_size => 12
      document.text ' '
      document.text "<b>3.#{section_index}.1  <c:uline>#{strand_display(strand).titlecase} - Differential Impact</b></c:uline>", :font_size => 12
      document.text ' '
      document
    end
    @pdf = generate_table(@pdf, table, :borders => [300, @page_width], :font_size => 10, :cell_format => cell_formats, :title_lines => 4, :table_title =>heading_proc)
    comments.each{|comment| @pdf.text comment}.to_s
    @pdf.text " "

  end

  def build_section(section, strand, heading_proc)
    table_data = []
    borders = [300, @page_width]
    information = @activity.questions.where(:strand => strand, :section => section, :needed => true).order(:name).sort{|a, b| a.name.slice(/\d+\z/).to_i <=> b.name.slice(/\d+\z/).to_i}
    # information.sort!{|a, b| a.name.slice(/\d+\z/) <=> b.name.slice(/\d+\z/)}
    cell_formats = []
    heading_proc.call(@pdf)
    information.each do |question|
      comments = get_comments(question.name)
      question_text = question.label
      response = question.display_response
      if question.input_type == "text"
        #Write out what's been tabled so far since we'll need to start a new table after inserting the text reply
        @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats, :title_lines => 4)
        table_data = []
        cell_formats = []

        #write out question text
        @pdf.text "<b>#{question_text}</b>"
        @pdf.text response
        if question.different_answer? && !@activity.approved
          @pdf.text "<b><i>Previously: #{question_text}</i></b>"
          @pdf.text "<i>#{question.previous.display_response}</i>"
        end
        #write out comments
        comments.map{|comment| @pdf.text comment} if comments.present?
        @pdf.text(" ")

      else
        #carry on constructing the table
        table_data << [question_text, response]
        table_data << ["Previously: " + question_text, question.previous.display_response].map{|a| "<i>#{a}</i>"} if question.different_answer? && !@activity.approved
        cell_formats << [{:shading => SHADE_COLOUR}, nil]
        cell_formats << [{:shading => SHADE_COLOUR}, nil] if question.different_answer?
        if comments.present?
          #again, need to kill the table and start again if there are any comments
          @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats, :title_lines => 4)
          table_data = []
          cell_formats = []
          comments.map{|comment| @pdf.text comment}
          @pdf.text(" ")
        end
      end
    end
    if table_data.present? #write the table if there's still stuff in the array.
      @pdf = generate_table(@pdf, table_data, :borders => borders, :font_size => 10, :cell_format => cell_formats, :title_lines => 4)
      @pdf.text(" ")
    end
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
      row <<  @activity.questions.find_by(name: "additional_work_#{strand}_4").display_response
      row_cell_format << nil
      if strand.to_s == 'gender' then
        row << " "
        row_cell_format << {:shading => SHADE_COLOUR}
      else
        row << @activity.questions.find_by(name: "additional_work_#{strand}_6").display_response
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
      row << @activity.questions.find_by(name: "additional_work_disability_7").display_response
      row << @activity.questions.find_by(name: "additional_work_disability_8").display_response
      row << @activity.questions.find_by(name: "additional_work_disability_9").display_response
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
      @pdf.text(@activity.review_on.strftime('%d/%m/%y').to_s, :font_size => 10)
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
      impact_enabled =  @activity.questions.find_by(name: "impact_#{strand}_9").response == 1
      consultation_enabled =  @activity.questions.find_by(name: "consultation_#{strand}_7").response == 1
      strand_issues = @activity.issues.where(strand: strand)
      strand_issues = strand_issues.where.not( section: 'impact' ) unless impact_enabled
      strand_issues = strand_issues.where.not( section: 'consultation' ) unless consultation_enabled

      next if strand_issues.blank?
      heading_proc = lambda do |document|
        document.text "<b>5.#{index}  #{strand_display(strand).titlecase}</b>", :font_size => 12
        document.text ' ', :font_size => 10
        document
      end
      title_lines = 4
      index += 1
      heading_proc.call(@pdf)
      strand_issues.each do |issue|
        table = []
        table << ["Issue", issue.description]
        table << ["Previous Issue", issue.previous_issue.description].map{|i| "<i>#{i}</i>"} if issue.previous_issue && issue.description != issue.previous_issue.description
        @pdf = generate_table(@pdf, table, :borders => borders, :font_size => 10, :col_format => [{:shading => SHADE_COLOUR}, nil], :title_lines => title_lines)
        table = []

        ["<b>Action</b>", issue.actions.to_s, " "].each{|a| @pdf.text a}
        ["<b>Previous Action</b>", issue.previous_issue.actions.to_s, " "].map{|i| "<i>#{i}</i>"}.each{|a| @pdf.text a} if issue.previous_issue && issue.actions != issue.previous_issue.actions
        ["<b>Resources</b>", issue.resources.to_s, " "].each{|a| @pdf.text a}
        ["<b>Previous Resources</b>", issue.previous_issue.resources.to_s, " "].map{|i| "<i>#{i}</i>"}.each{|a| @pdf.text a} if issue.previous_issue && issue.resources != issue.previous_issue.resources
        table << ["Target Start Date", issue.timescales ? issue.timescales.strftime("%d/%m/%Y").to_s : "N/A"]
        table << ["Previous Target Start Date", issue.previous_issue.timescales.strftime("%d/%m/%Y").to_s].map{|i| "<i>#{i}</i>"} if issue.previous_issue && issue.timescales != issue.previous_issue.timescales
        table << ["Target Completion Date", issue.completing ? issue.completing.strftime("%d/%m/%Y").to_s : "N/A"]
        table << ["Previous Target Completion Date", issue.previous_issue.completing.strftime("%d/%m/%Y").to_s].map{|i| "<i>#{i}</i>"} if issue.previous_issue && issue.completing != issue.previous_issue.completing
        table << ["Lead Officer", issue.lead_officer_email.to_s]
        table << ["Previous Lead Officer", issue.previous_issue.lead_officer_email.to_s].map{|i| "<i>#{i}</i>"} if issue.previous_issue && issue.lead_officer != issue.previous_issue.lead_officer
        @pdf = generate_table(@pdf, table, :borders => borders, :font_size => 10, :col_format => [{:shading => SHADE_COLOUR}, nil])
        table = []

        ["<b>Recommendations</b>", issue.recommendations, " "].each{|a| @pdf.text a}
        ["<b>Previous Recommendations</b>", issue.previous_issue.recommendations, " "].map{|i| "<i>#{i}</i>"}.each{|a| @pdf.text a} if issue.previous_issue && issue.recommendations != issue.previous_issue.recommendations
        ["<b>Monitoring</b>", issue.monitoring, " "].each{|a| @pdf.text a}
        ["<b>Previous Monitoring</b>", issue.previous_issue.monitoring, " "].map{|i| "<i>#{i}</i>"} if issue.previous_issue && issue.monitoring != issue.previous_issue.monitoring
        ["<b>Outcomes</b>", issue.outcomes, " "].each{|a| @pdf.text a}
        ["<b>Previous Outcomes</b>", issue.previous_issue.outcomes, " "].map{|i| "<i>#{i}</i>"}.each{|a| @pdf.text a} if issue.previous_issue && issue.outcomes != issue.previous_issue.outcomes

        @pdf.text ' '
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
