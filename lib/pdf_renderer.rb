class PDFRenderer < Ruport::Renderer
  stage :pre_processed, :body, :statistics, :issues, :footer

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => PDFRenderer
    def build_pre_processed
      pdf_writer.save_state
      #The page numbers are started at the top, so that they will always hit the first page, but they appear at the bottom
      pdf_writer.start_page_numbering(pdf_writer.absolute_left_margin, pdf_writer.absolute_bottom_margin, 12, :left)
      #This creates the grey Unapproved background.
      colour = 'Gainsboro'
      pdf_writer.fill_color Color::RGB.const_get(colour)
      pdf_writer.add_text(pdf_writer.margin_x_middle-150, pdf_writer.margin_y_middle-150, data[1].to_s, 72, 45)
      pdf_writer.restore_state
      render_pdf
    end
    def build_body
      pdf_writer.save_state
      pdf_writer.fill_color Color::RGB.const_get('Black')
      pdf_writer.text "<b>#{data[3]}</b>", :justification => :center, :font_size => 18
      pdf_writer.text "Impact Equality Activity Report", :justification => :center, :font_size => 12
      add_text " " #Serves as a new line character. Is this more readable than moving the cursor manually?
      add_text "<b>Directorate</b>: #{data[2].to_s}"
      add_text " "
      add_text "<b>Activity</b>"
      move_cursor_to(cursor - 7)
      pdf_writer.stroke_style! pdf_writer.class::StrokeStyle.new(1, :dash => { :pattern => [2, 1], :phase => 2 })
      hr
      pdf_writer.restore_state
      table = Table("description", "volatile_data")
      table << ["<b>Name</b>:", data[0].to_s]
      table << ["<b>Type</b>:", data[4].to_s]
      table << ["<b>Managers email</b>:", data[5].to_s]
      table << ["<b>Approver</b>:", data[6].to_s]    
      draw_table(table, :position=> :left, :orientation => 2, :shade_rows => :none, :show_lines => :none, :show_headings => false)
      add_text " "
      add_text "<b>Activity Target Outcome</b>"
      move_cursor_to(cursor - 7)
      pdf_writer.stroke_color! Color::Black
      pdf_writer.stroke_style! pdf_writer.class::StrokeStyle.new(1, :dash => { :pattern => [2, 1], :phase => 2 })
      hr
      add_text data[7].to_s
      add_text " "
   end
   
    def build_statistics
      if data[8]
        statistics = data[8]
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
        draw_table(statistics_table, :shade_rows => :none, :show_lines => :all)
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
        draw_table(statistics_impact_table, :shade_rows => :none, :show_lines => :all)        
      else
        add_text " "
        add_text "Project details have not yet calculated as the Activity has not been completed."
        add_text " "
      end
      render_pdf 
    end
    
    def build_issues

    end
    def build_footer
      pdf_writer.open_object do |footer|
        pdf_writer.save_state
        pdf_writer.stroke_color! Color::RGB::Black
        pdf_writer.stroke_style! pdf_writer.class::StrokeStyle::DEFAULT
        font_size = 12
        text = "Report Produced: #{Time.now}"
        y = pdf_writer.absolute_bottom_margin
        width = pdf_writer.text_width(text, font_size)
        margin = pdf_writer.absolute_right_margin
        pdf_writer.add_text(margin - width, y, text, font_size)
        left_margin = pdf_writer.absolute_left_margin
        right_margin = pdf_writer.absolute_right_margin
        y += (pdf_writer.font_height(font_size) * 1.01)
        pdf_writer.line(left_margin, y, right_margin, y).stroke
        pdf_writer.restore_state
        pdf_writer.close_object
        pdf_writer.add_object(footer, :all_pages)
      end
      render_pdf 
    end
  end
end