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

class SchedulePDFGenerator

  SHADE_COLOUR = Color::RGB::Grey90

  def initialize(activities)
    @pdf = PDF::Writer.new(:paper => "A4")
    @page_width = @pdf.absolute_right_margin - @pdf.absolute_left_margin
    @activities = activities
    
    @table_data = {:v_padding => 5, :header => table_header}
    @header_data = {:v_padding => 5}
    methods_to_call =  [:page_numbers,:footer, :header, :body]
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
  
  def build_header
      @pdf.fill_color Color::RGB.const_get('Black')
      # @pdf.image( "#{Rails.root}/public/images/header_bg.jpg", :justification => :center, :resize => 0.5)
      @pdf.text "<b>Birmingham City Council</b>", :justification => :center, :font_size => 22
      @pdf.text " ", :justification => :center, :font_size => 10
      @pdf.text "<c:uline><b>Birmingham City Council EA Toolkit Schedule Report</b></c:uline>", :justification => :center, :font_size => 14
      @pdf.text " ", :justification => :center, :font_size => 10 #Serves as a new line character. Is this more readable than moving the cursor manually?
    return @pdf
  end
  
  def build_body
    table = []
    heading_row = ["Service Area", "Reference", "Task Group Leader", "Name", "Status", "Progress", "Completion Date", "Relevant", "Action Plan Submitted"]
    table << heading_row
    @activities.each do |activity|
      table << [activity.service_area.name, activity.ref_no, activity.completer.email, activity.name, activity.activity_status_name, activity.full_progress, activity.end_date, activity.activity_relevant? ? "Yes" : "No", "Action Plan Submitted"]
    end
    @pdf = generate_table(@pdf, table, :borders => [60,120,180,240,300,360,420,480,540],:row_format => [{:shading => SHADE_COLOUR}, nil])
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
