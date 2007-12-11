class OrganisationPDFRenderer < Ruport::Renderer
  stage :page_numbers, :header, :activities_table, :progress_table, :results_table, :footer

  class OrganisationPDF < Ruport::Formatter::PDF
    renders :pdf, :for => OrganisationPDFRenderer
    
    def build_page_numbers
      pdf_writer.start_page_numbering(pdf_writer.absolute_left_margin,
        pdf_writer.absolute_bottom_margin - (pdf_writer.font_height(12) * 1.01),
        12,
        :left)
    end
    
    def build_header
      pdf_writer.fill_color Color::RGB.const_get('Black')
      pdf_writer.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center, :resize => 0.5)
      pdf_writer.text "<b>#{data[0]}</b>", :justification => :center, :font_size => 18
      pdf_writer.text "Impact Equality#{153.chr} Organisation Report", :justification => :center, :font_size => 12
      pdf_writer.text "", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
      add_text " "
      add_text " "
    end
    
    def build_activities_table
      pdf_writer.text "<b>Activity Type</b>", :justification => :left, :font_size => 12
      add_text " "
      table = Table("Types", "Number")
      table << ["Existing Function", data[1]]
      table << ["Proposed Function", data[2]]
      table << ["Existing Policy", data[3]]
      table << ["Proposed Policy", data[4]]
      table << ["Total", data[5]]
      draw_table(table, :position=> :left, :orientation => 2)
      add_text " "
    end
    
    def build_progress_table
      add_text "<b>Progress</b>"
      add_text " "
      table = Table("", "Started", "Completed", "Approved")
      data[6].each do |section, value|
        table << [section.to_s.titleize, value].flatten
      end
      draw_table(table, :position=> :left, :orientation => 2)
      add_text " "
    end
    
    def build_results_table
      add_text "<b>Results</b>"
      add_text " "
      table = Table("Priority Level", "Low Impact", "Medium Impact", "High Impact")
      data[7].each do |priority_ranking, value|
        table << ["Priority #{priority_ranking}", value[:low], value[:medium], value[:high]]
      end
      draw_table(table, :position=> :left, :orientation => 2)
      add_text " "
    end
    
    def build_footer
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
      pdf_writer.stop_page_numbering(true)
      render_pdf 
    end
  end
end
