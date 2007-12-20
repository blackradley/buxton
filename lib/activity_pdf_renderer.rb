class ActivityPDFRenderer < Ruport::Renderer
  stage :page_numbers, :footer, :unapproved_logo_on_first_page, :header, :body, :statistics, :issues, :render
end 
#TODO: Find much better way of ignoring not wanted sections.
class ActivityPDF < Ruport::Formatter::PDF
  renders :pdf, :for => ActivityPDFRenderer
  def build_page_numbers
    if data[11].include?(:page_numbers)
      pdf_writer.set_proxy(nil)
      pdf_writer.start_page_numbering(pdf_writer.absolute_left_margin,
        pdf_writer.absolute_bottom_margin - (pdf_writer.font_height(12) * 1.01),
        12,
        :left)
    end
  end
  def build_unapproved_logo_on_first_page
    if data[11].include?(:unapproved_logo_on_first_page) then
      pdf_writer.unapproved_status = data[1] 
      #The page numbers are started at the top, so that they will always hit the first page, but they appear at the bottom
      #This creates the grey Unapproved background.
      colour = 'Gainsboro'
      pdf_writer.save_state
      pdf_writer.fill_color Color::RGB.const_get(colour)
      pdf_writer.add_text(pdf_writer.margin_x_middle-150, pdf_writer.margin_y_middle-150, data[1].to_s, 72, 45)
      pdf_writer.restore_state
    end
  end
  def build_header
    if data[11].include?(:header) then
      pdf_writer.fill_color Color::RGB.const_get('Black')
      pdf_writer.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      pdf_writer.text "<b>#{data[3]}</b>", :justification => :center, :font_size => 18
      pdf_writer.text "Impact Equality#{153.chr} Activity Report", :justification => :center, :font_size => 12
      pdf_writer.text "", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
      add_text " "
    end
  end
  def build_body
    if data[11].include?(:body) then
      pdf_writer.save_state
      add_text "<b>Directorate</b>: #{data[2].to_s}"
      add_text " "
      pdf_writer.text "<b>Activity</b>", :justification => :left, :font_size => 12
      move_cursor_to(cursor - 7)
      pdf_writer.stroke_style! pdf_writer.class::StrokeStyle.new(1, :dash => { :pattern => [2, 1], :phase => 2 })
      hr
      pdf_writer.restore_state
      table = Table("description", "volatile_data")
      table << ["<b>Name</b>:", data[0].to_s]
      table << ["<b>Type</b>:", data[4].to_s]
      table << ["<b>Managers email</b>:", data[5].to_s]
      table << ["<b>Approver</b>:", data[6].to_s] if data[1].blank?
      table << ["<b>Approved on:</b>", data[8].to_s] if data[1].blank?
      table << ["<b>Activity Target Outcome</b>", ""]
      draw_table(table, :position=> :left, :orientation => 2, :shade_rows => :none, :show_lines => :none, :show_headings => false)
      pdf_writer.text data[7].to_s, :justification => :left, :font_size => 10
      add_text " "
    end
 end
 
  def build_statistics
    if data[11].include?(:statistics) then
      if data[9]
        statistics = data[9]
        relevance = statistics.relevance
        stat_fun = statistics.function
        priority_table = []
        priority_table << stat_fun.priority_ranking(:gender)
        priority_table << stat_fun.priority_ranking(:race)
        priority_table << stat_fun.priority_ranking(:disability)
        priority_table << stat_fun.priority_ranking(:faith)
        priority_table << stat_fun.priority_ranking(:sexual_orientation)
        priority_table << stat_fun.priority_ranking(:age)
        add_text "<b>Activity Relevant?</b>: #{if relevance then "Yes" else "No" end}"
        add_text " "
        add_text "<b>Priority</b>: (1-5)"
        add_text " "
        pdf_writer.stroke_color! Color::RGB::Black
        pdf_writer.stroke_style! pdf_writer.class::StrokeStyle::DEFAULT        
        statistics_table = Table(['Gender', 'Race', 'Disability', 'Faith', 'Sexual Orientation', 'Age'])
        statistics_table << priority_table
        draw_table(statistics_table, :shade_rows => :none,
          :font_size => 10, :heading_font_size => 10, :show_lines => :all)
        pdf_writer.text "(Priority is rated 1 to 5, with 5 representing the highest priority level)", :justification => :center
        pdf_writer.text " ", :justification => :left
        add_text "<b>Impact</b>: (High, Medium, Low)"
        add_text " "
        impact_table = []
        impact_table << stat_fun.topic_impact(:gender).to_s.capitalize
        impact_table << stat_fun.topic_impact(:race).to_s.capitalize
        impact_table << stat_fun.topic_impact(:disability).to_s.capitalize
        impact_table << stat_fun.topic_impact(:faith).to_s.capitalize
        impact_table << stat_fun.topic_impact(:sexual_orientation).to_s.capitalize
        impact_table << stat_fun.topic_impact(:age).to_s.capitalize
        pdf_writer.stroke_color! Color::RGB::Black
        pdf_writer.stroke_style! pdf_writer.class::StrokeStyle::DEFAULT        
        statistics_impact_table = Table(['Gender', 'Race', 'Disability', 'Faith', 'Sexual Orientation', 'Age'])
        statistics_impact_table << impact_table
        draw_table(statistics_impact_table, :shade_rows => :none,
          :font_size => 10, :heading_font_size => 10, :show_lines => :all)        
      else
        add_text " "
        add_text "Project details have not yet calculated as the Activity has not been completed."
        add_text " "
      end
    end
  end
  
  def build_issues
    if data[11].include?(:issues) then
      pdf_writer.text "<b>Issues</b>", :justification => :left, :font_size => 12
      move_cursor_to(cursor - 7)
      pdf_writer.stroke_color! Color::RGB::Black
      pdf_writer.stroke_style! pdf_writer.class::StrokeStyle.new(1, :dash => { :pattern => [2, 1], :phase => 2 })
      hr      
      activity_id = data[10]
      issues_table = Issue.report_table(
        :all,
        :conditions => {:activity_id => activity_id},
        :except => %w(id activity_id section)
        )
      columns = issues_table.column_names
      no_strand_cols = columns.clone.to_a
      no_strand_cols.delete('strand')
      wordings = Activity.find(activity_id).hashes['wordings']
      pdf_writer.stroke_color! Color::RGB::Black
      pdf_writer.stroke_style! pdf_writer.class::StrokeStyle::DEFAULT      
      wordings.each do |strand_name, wording|
        unless issues_table.sub_table(columns){|row| row.strand.to_s == strand_name.to_s}.to_a == [] then
          add_text " "
          pdf_writer.text "<b>Issues pertaining to #{wording}</b>", :justification => :left, :font_size => 10
          add_text " "
          issue_table = issues_table.sub_table(columns){|row|row.strand.to_s == strand_name.to_s}.sub_table(no_strand_cols)
          issue_table_renamed_columns = []
          issue_table.column_names.each do |column|
            issue_table_renamed_columns << column.titleize if column
          end
          issue_table.rename_columns(issue_table.column_names, issue_table_renamed_columns)
          draw_table(issue_table, :shade_rows => :none, :show_lines => :all, :font_size => 10, :heading_font_size => 10, :width => 500)
          issue_table = nil
        end
      end
    end
  end
  
  def build_footer
    if data[11].include?(:footer) then
      pdf_writer.open_object do |footer|
        pdf_writer.save_state
        pdf_writer.stroke_color! Color::RGB::Black
        pdf_writer.stroke_style! pdf_writer.class::StrokeStyle::DEFAULT
        font_size = 12
        text = "Report Produced: #{Time.now}"
        y = pdf_writer.absolute_bottom_margin - (pdf_writer.font_height(font_size) * 1.01)
        width = pdf_writer.text_width(text, font_size)
        margin = pdf_writer.absolute_right_margin
        pdf_writer.add_text(margin - width, y, text, font_size)
        left_margin = pdf_writer.absolute_left_margin
        right_margin = pdf_writer.absolute_right_margin
        y = pdf_writer.absolute_bottom_margin
        pdf_writer.line(left_margin, y, right_margin, y).stroke
        pdf_writer.restore_state
        pdf_writer.close_object
        pdf_writer.add_object(footer, :all_pages)
      end
    end
  end
  
  def build_render
    pdf_writer.stop_page_numbering(true)
    render_pdf
  end
end
