  require 'rubygems'
  require 'pdf/writer'
  require 'pdf/simpletable'

class ActivityPDFGenerator

  def initialize(data)
     a = Time.now
    @pdf = PDF::Writer.new
    data[11].each do |operation|
      @pdf = self.send("build_#{operation.to_s}", @pdf, data)
    end
    @pdf.stop_page_numbering(true)
  end

  def pdf
    @pdf
  end

  def build_page_numbers(pdf, data)
      pdf.set_proxy(nil)
      pdf.start_page_numbering(pdf.absolute_left_margin,
        pdf.absolute_bottom_margin - (pdf.font_height(12) * 1.01) - 5,
        12,
        :left)
  return pdf
  end
  def build_unapproved_logo_on_first_page(pdf, data)
      pdf.unapproved_status = data[1]
      #The page numbers are started at the top, so that they will always hit the first page, but they appear at the bottom
      #This creates the grey Unapproved background.
      colour = 'Gainsboro'
      pdf.save_state
      pdf.fill_color Color::RGB.const_get(colour)
      pdf.add_text(pdf.margin_x_middle-150, pdf.margin_y_middle-150, data[1].to_s, 72, 45)
      pdf.restore_state
    return pdf
  end
  def build_header(pdf, data)
      pdf.fill_color Color::RGB.const_get('Black')
      pdf.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      pdf.text "<b>#{data[3]}</b>", :justification => :center, :font_size => 18
      pdf.text "Impact Equality#{153.chr} Activity Report", :justification => :center, :font_size => 12
      pdf.text "", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
      pdf.text " "
    return pdf
  end
  def build_body(pdf, data)
      pdf.save_state
      pdf.text "<b>#{data[12]}</b>: #{data[2].to_s}"
      pdf.text " "
      pdf.text "<b>Activity</b>", :justification => :left, :font_size => 12
      pdf.y -= 7
      pdf.stroke_color! Color::RGB::Black
      pdf.stroke_style! PDF::Writer::StrokeStyle.new(1, :dash => { :pattern => [2, 1], :phase => 2 })
      left_margin = pdf.absolute_left_margin
      right_margin = pdf.absolute_right_margin
      pdf.line(left_margin, pdf.y, right_margin, pdf.y).stroke
      pdf.restore_state
      table = []
      table << {'description' =>"<b>Name</b>:", 'data' => data[0].to_s}
      table << {'description' =>"<b>Type</b>:", 'data' => data[4].to_s}
      table << {'description' =>"<b>Managers email</b>:", 'data' => data[5].to_s}
      table << {'description' =>"<b>Approver</b>:", 'data' => data[6].to_s} if data[1].to_s == ""
      table << {'description' =>"<b>Approved on:</b>", 'data' => data[8].to_s} if data[1].to_s == ""
      table << {'description' =>"<b>Activity Target Outcome</b>", 'data' =>  ""}
      tab = PDF::SimpleTable.new()
      tab.data = table
      tab.column_order = [ "description", "data" ]
      tab = table_formatter(tab, :formatting)
      tab.render_on(pdf)
      pdf.text data[7].to_s, :justification => :left, :font_size => 10
      pdf.text " "
    return pdf
 end

  def build_statistics(pdf, data)
      if data[9].completed
        stat_fun = data[9]
        priority_table = [{}]
        impact_table = [{}]
        data[9].hashes['wordings'].keys.each do |strand|
          priority_table[0][strand.titleize] = stat_fun.priority_ranking(strand.to_sym)
          impact_table[0][strand.titleize] = stat_fun.impact_wording(strand.to_sym).to_s.titleize
        end
        pdf.text "<b>Activity Relevant?</b>: #{if stat_fun.relevant? then "Yes" else "No" end}"
        pdf.text " "
        pdf.text "<b>Priority</b>: (1-5)"
        pdf.text " "
        pdf.stroke_color! Color::RGB::Black
        pdf.stroke_style! pdf.class::StrokeStyle::DEFAULT
        statistics_table = PDF::SimpleTable.new()
        statistics_table.column_order = ['Gender', 'Race', 'Disability', 'Faith', 'Sexual Orientation', 'Age']
        statistics_table.data = priority_table
        statistics_table = table_formatter(statistics_table, :standard)
        statistics_table.render_on(pdf)
        pdf.text "(Priority is rated 1 to 5, with 5 representing the highest priority level)", :justification => :center
        pdf.text " ", :justification => :left
        pdf.text "<b>Impact</b>: (High, Medium, Low)"
        pdf.text " "
        pdf.stroke_color! Color::RGB::Black
        pdf.stroke_style! pdf.class::StrokeStyle::DEFAULT
        statistics_impact_table = PDF::SimpleTable.new()
        statistics_impact_table.column_order = ['Gender', 'Race', 'Disability', 'Faith', 'Sexual Orientation', 'Age']
        statistics_impact_table.data = impact_table
        statistics_impact_table= table_formatter(statistics_impact_table, :standard)
        statistics_impact_table.render_on(pdf)
	      pdf.text " "
      else
        pdf.text " "
        pdf.text "Project details have not yet calculated as the Activity has not been completed."
        pdf.text " "
      end
    return pdf
  end

  def build_issues(pdf, data)
    if data[9].issues.size > 0 then
      pdf.text "<b>Issues</b>", :justification => :left, :font_size => 12
      pdf.y -= 7
      pdf.stroke_color! Color::RGB::Black
      pdf.stroke_style! PDF::Writer::StrokeStyle.new(1, :dash => { :pattern => [2, 1], :phase => 2 })
      left_margin = pdf.absolute_left_margin
      right_margin = pdf.absolute_right_margin
      pdf.line(left_margin, pdf.y, right_margin, pdf.y).stroke
      pdf.stroke_color! Color::RGB::Black
      pdf.stroke_style! PDF::Writer::StrokeStyle::DEFAULT
      issues_hash = {}
      issues = data[14]
      issues.each do |title, contents|
        next if contents == []
	pdf = construct_issue_table(pdf, title, contents, data[13])
      end
    else
      pdf.text "There are no issues for this activity"
    end
    return pdf
  end

  def construct_issue_table(pdf, title, contents, column_order)
    issue_table = PDF::SimpleTable.new()
    issue_table.column_order = column_order
    issue_table.data = contents
    pdf.start_new_page if pdf.y < 50 #Hack to prevent 8 page table bug
    pdf.text "<b>#{title}</b>", :justification => :left, :font_size => 10
    pdf.y -= 5
    issue_table = table_formatter(issue_table, :standard)
    pdf.start_new_page if pdf.y < 50 #Hack to prevent 8 page table bug
    issue_table.render_on(pdf)
    pdf.y -= 5
    pdf
  end
  def build_footer(pdf, data)
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
  private
  def table_formatter(table, type)
    case type
      when :formatting
        table.position = :left
        table.orientation = 2
        table.shade_rows = :none
        table.show_lines = :none
        table.show_headings = false
        table
      when :standard
        table.position = pdf.left_margin + 10
        table.orientation = :right
        table.shade_rows = :none
        table.font_size = 10
        table.heading_font_size = 10
        table.show_lines = :all
        table.width = 500
        table.split_rows = true
        table
    end
  end
end
