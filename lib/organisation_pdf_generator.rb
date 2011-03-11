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

class OrganisationPDFGenerator

  def initialize(organisation, name)
    @pdf = PDF::Writer.new
    @name = name
    methods_to_call =  [:page_numbers, :footer, :header, :progress_table, :results_table]
    methods_to_call.each do |operation|
      @pdf = self.send("build_#{operation.to_s}", @pdf, organisation)
    end
    @pdf.stop_page_numbering(true)
  end

  def pdf
    @pdf
  end
  def build_page_numbers(pdf, organisation)
    pdf.start_page_numbering(pdf.absolute_left_margin,
      pdf.absolute_bottom_margin - (pdf.font_height(12) * 1.01) - 5,
      12,
      :left)
    pdf
  end

  def build_header(pdf, organisation)
    pdf.fill_color Color::RGB.const_get('Black')
    pdf.image( "#{Rails.root}/public/images/pdf_logo.png", :justification => :center, :resize => 0.6)
    pdf.text "<b>#{organisation.name}</b>", :justification => :center, :font_size => 19
    pdf.text "#{@name} Summary Report", :justification => :center, :font_size => 12
    pdf.text "" #Serves as a new line character. Is this more readable than moving the cursor manually?
    pdf.text " "
    return pdf
  end
  def build_progress_table(pdf, organisation)
    pdf.text "<b>Progress Table</b>", :justification => :center
    pdf.text " "
    pdf.text "The Progress Table below shows how many activities (i.e. functions and policies) have started or completed the equalities impact assessment process.", :justification => :center
    pdf.text " "
    table = []
    table << ['Activities', 'Number']
    table << ['Identified', organisation.activities.size]
    table << ["Started", organisation.activities.reject{|activity| !activity.started}.size]
    table << ['Completed', organisation.activities.reject{|activity| !activity.completed}.size]
    pdf = generate_table(pdf, table, {:borders => [100, 150], :alignment => :center})
    pdf.text " "
    pdf    
  end
  def build_results_table(pdf, organisation)
    pdf.text "<b>Results</b>", :justification => :center
    pdf.text " "
    pdf.text "For those activities which have completed the assessment, the Results Table below shows the number where there may be a problem: the further towards the top right, the more important.", :justification => :center
    pdf.text " "
    table = []
    table << ["", "<b>Potential Impact</b>**"]
    table << ["<b>Priority</b>*", "<b>Low Impact</b>", "<b>Medium Impact</b>", "<b>High Impact</b>"]
    organisation.results_table.to_a.sort.reverse.each do |priority_ranking, value|
      table << ["Priority #{priority_ranking}", value[:low], value[:medium], value[:high]]
    end
    pdf = generate_table(pdf, table, {:borders => [100,200,300,400], :alignment => :center})
    pdf.text " ", :font_size => 10
    pdf.text "<i>*Priority #{45.chr} a measure of how urgent it is that this activity undertake a full action planning assessment exercise.</i>", :justification => :center
    pdf.text "<i>**Potential Impact #{45.chr} the effect this activity could have on achieving and promoting equality.</i>", :justification => :center
    pdf
  end

  def build_footer(pdf, organisation)
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
  #Custom implementation on SimpleTable. Creates a table in 0.08 seconds as opposed to simpletables 0.7.
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
