class PDFRenderer < Ruport::Renderer
  stage :unapproved_background, :header, :timestamp

  class PDF < Ruport::Formatter::PDF
    renders :pdf, :for => PDFRenderer
    def build_unapproved_background
      colour = 'Gainsboro'
      pdf_writer.fill_color Color::RGB.const_get(colour)
      pdf_writer.add_text(pdf_writer.margin_x_middle-150, pdf_writer.margin_y_middle-150, data[1], 72, 45)
      render_pdf
    end
    def build_header
      pdf_writer.fill_color Color::RGB.const_get('Black')
      pdf_writer.text data[0], :justification => :center, :font_size => 16
      pdf_writer.text "\n"
      pdf_writer.text "Directorate: #{data[2]}", :justification => :left, :font_size => 14
      pdf_writer.text "Activity -----------------------------------------------------", :justification => :left, :font_size => 14
      render_pdf 
    end
    def build_timestamp
      pdf_writer.text "Report Produced: #{Time.now}", :justification => :right, :font_size => 10
    end
  end
end