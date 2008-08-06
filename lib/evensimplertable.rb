#Custom implementation on SimpleTable. Creates a table in 0.08 seconds as opposed to simpletables 0.7 by redoing some time consuming
#procedures involved in working out page wraps and initializing objects as opposed to using arrays.

# table_data is a hash, which can take the following keys:
# :offset => The offset of the table relative to it's alignment. :aligment => aligns the table   ??? Ask Joe
# :show lines => :all shows all lines, 
#                :borders shows the column separators only, 
#                :none shows no lines. 
#                :edges shows only the table edges
# :borders => sets the positions of the column divides (for example [0, 100, 200, 300] gives 3 columns, each 100 pixels in width
# Defaults to n columns of width (right margin - left margin) / n, where n is the length of the first element of table_data
# A row will autosize to the correct height. A gotcha is that if you specify an offset, it takes it from the left
# of the page instead of from the left boundary. To be fixed
# :empty_lines => sets the number of blank lines to be printed after cell data. Default is 1
# :h_padding => sets the number of pixels to pad the left and right of each cell by. Default is 0
# :t_padding => sets the number of pixels to pad above text in cells. Default is 0
# :b_padding => sets the number of pixels to pad below text in cells. Default is 0
# :text_colour => sets the colour for the table. Defaults to previous colour setting
# :row_format => An array of table_data, each element corresponding to the equivalent row (match by index)
# :col_format => An array of table_data, each element corresponding to the equivalent column. Column formatting will overwrite row formatting
# :cell_format => An array of :col_formats, each element corresponding to the equivalent row. Cell formatting will overwrite column formatting
# If either :col_format or :cell format arrays are too short, any extra columns/cells assume their default values
# Simple table is still enabled, so if you need functionality that isn't here, then use that.

module PDFExtensions
  attr_accessor :current_page_number
  
  def generate_table(pdf, table, table_data = @table_data)
    @current_page_number = 1
    is_one_page = true
    x_pos = table_data[:offset]
    borders = table_data[:borders] ? table_data[:borders] : generate_equal_columns(pdf, table[0].length)
    pdf.fill_color table_data[:text_colour]  if table_data[:text_colour]
    show_lines = table_data[:show_lines].nil? ? :all : table_data[:show_lines]
    table_data[:text_alignment] = :left unless table_data[:text_alignment]
    init_pos = x_pos || pdf.absolute_left_margin
    init_pos = pdf.absolute_x_middle - borders.last/2 + x_pos.to_i  if table_data[:alignment] == :center
    init_pos = pdf.absolute_right_margin - borders.last + x_pos.to_i  if table_data[:alignment] == :right
    right_edge = borders.last + init_pos
    top_of_table = pdf.y
    #insert heading
    pdf = table_data[:header].call(pdf, *table_data[:header_args]) if table_data[:header]
    #draw table
    table.each_with_index do |row, row_index|
      lines = 1
      row_data(row).each_with_index do |cell, index|
        if index == 0 then
          width = borders[index]
        else
          width = borders[index] - borders[index - 1]
        end
        line_count = cell.size*((150.0/27)*(pdf.font_size/10.0))/width + 1 #Approximation of a width for characters
        lines = line_count if line_count > lines
      end
      #insert new page if table would overflow page
      if (pdf.y < (lines+1).to_i*pdf.font_height + pdf.absolute_bottom_margin) then
         pdf = page_overflow(pdf, show_lines, row_index, init_pos, top_of_table, right_edge, table_data)
         top_of_table = pdf.y
         is_one_page = false
      end
      borders_to_pass = borders.clone
      table_data_to_pass = table_data.clone
      if row.size != borders.size then
        borders_to_pass.pop while row.size < borders_to_pass.size
        borders_to_pass.pop
        borders_to_pass.push(borders.last)
        table_data_to_pass[:borders] = borders_to_pass
      end
      pdf = add_row(pdf, row_index, row, table_data_to_pass, init_pos, show_lines)
    end
    pdf = table_data[:footer].call(pdf, @current_page_number, *table_data[:footer_args].flatten) if table_data[:footer] && is_one_page
    pdf
  end

  private
  
  def add_row(pdf, row_index, row, table_data, x_pos = nil, lines = :all)
    #variable definitions for later in the method
    top_of_table = pdf.y
    text_top = pdf.y - pdf.font_height
    cell_settings = cell_details(row, table_data)
    borders = cell_settings[:borders]
    text_alignment = cell_settings[:text_alignment]
    pdf.y -= pdf.font_height
    max_height = 0    
    t_pad = 0
    b_pad = 0
    max_v_pad = 0
    x_pos = x_pos || pdf.absolute_left_margin
    init_pos = x_pos
    x_pos += 2
    cells_filled_to = []
    row_data(row).each_with_index do |cell, index|
      if index == 0 then
        width = borders[index]
        left_edge = pdf.absolute_left_margin
        right_edge = borders[index]
      else
        width = borders[index] - borders[index - 1]
        left_edge = borders[index - 1] + init_pos
        right_edge = borders[index]
      end
      cell_settings = cell_details(row, table_data)
      cell_settings = cell_details(table_data[:row_format][row_index], cell_settings) if table_data[:row_format]
      cell_settings = cell_details(table_data[:col_format][index], cell_settings) if table_data[:col_format]
      if table_data[:cell_format] && table_data[:cell_format][row_index]
        cell_settings = cell_details(table_data[:cell_format][row_index][index], cell_settings) 
      end
      t_pad = cell_settings[:t_padding] || cell_settings[:v_padding].to_i
      b_pad = cell_settings[:b_padding] || cell_settings[:v_padding].to_i
      indent = cell_settings[:h_padding] || 2
      if cell_settings[:text_alignment] == :right then
        x_pos -= 2
      end
      pdf.fill_color! cell_settings[:text_colour]  if cell_settings[:text_colour]
      pdf.y -= t_pad
      shade_area(pdf, cell_settings[:shading], left_edge, top_of_table, width, -(t_pad + 2))
      max_v_pad = t_pad + b_pad  if t_pad + b_pad > max_v_pad
      text_lines = cell.to_s.split(/\n/)
      current_height = cell_settings[:empty_lines] || 0
      text_lines.each_with_index do |line, line_index|
        pdf.y -= pdf.font_height  unless line_index == 0
        shade_area(pdf, cell_settings[:shading], left_edge, pdf.y - 2, width, pdf.font_height + 1)
        overflow = pdf.add_text_wrap(x_pos + indent, pdf.y + 2, width - 2 - 2*indent, line, 10, cell_settings[:text_alignment])
        current_height += 1  unless line_index == 0 
        while overflow.length > 0
          pdf.y -= pdf.font_height
          shade_area(pdf, cell_settings[:shading], left_edge, pdf.y - 2, width, pdf.font_height + 1)
          overflow = pdf.add_text_wrap(x_pos + indent, pdf.y + 2, width - 2 - 2*indent, overflow, 10, cell_settings[:text_alignment])
          current_height += 1
        end
      end
      cells_filled_to << [pdf.y, cell_settings[:shading]]
      max_height = current_height if current_height > max_height
      x_pos = borders[index] + init_pos + 2
      pdf.y = text_top
    end
    max_height = (max_height)*(pdf.font_height) + max_v_pad
    pdf.y -= max_height
    borders.each_index do |index|
      if index == 0
        start = pdf.absolute_left_margin
        width = borders[0]
      else
        start = borders[index - 1] + init_pos
        width = borders[index] - borders[index - 1]
      end
      shade_area(pdf, cells_filled_to[index][1], start, cells_filled_to[index][0], width, pdf.y - cells_filled_to[index][0] - 4)
    end
    pdf.y -= 4
    draw_lines(init_pos, top_of_table, pdf.y, borders, lines, row_index)
    pdf
  end

  def draw_lines(left, top, bottom, borders, lines, index)
    right = borders.last + left
    if (lines == :all || lines == :borders || lines == :edges)
      # top line
      if lines == :all || index == 0
        pdf.line(left, top, right, top).stroke # if index == 0
      end
      # left line
      pdf.line(left, top, left, bottom).stroke
      # right line
      pdf.line(right, top, right, bottom).stroke
      # bottom line
      pdf.line(left, bottom, right, bottom).stroke
      # Other vertical lines
      if lines == :all || lines == :borders
        borders.each_with_index do |border, index|
          pdf.line(border + left, top, border + left, bottom).stroke
        end
      end
    end    
  end


  def shade_area(pdf, colour, x, y, width, height)
    if colour
      pdf_background = pdf.fill_color?
      line_weight = pdf.stroke_style?.width
      pdf.fill_color colour
      pdf.rectangle(x, y, width, height).fill
      pdf.fill_color pdf_background
    end
  end

  def row_data(row)
    row_data = row
    if row.class == Hash then
      row_data = row[:data]
    end
    row_data    
  end
  
  def cell_details(cell_data, table_data)
    cell_settings = table_data.clone
    if cell_data.class == Hash then
      cell_data.each do |key, value|
        cell_settings[key] = value
      end
    end  
    cell_settings
  end 
  
  def page_overflow(pdf, show_lines, row_index, init_pos, top_of_table, right_edge, table_data)
    color = pdf.stroke_color?
    fill_color = pdf.fill_color?
#    pdf.line(init_pos, top_of_table, init_pos, pdf.y - 4).stroke if (show_lines == :all || show_lines == :borders) && row_index != 0
#    pdf.line(init_pos, pdf.y - 4, right_edge, pdf.y - 4).stroke if (show_lines == :all || show_lines == :borders)
    pdf.y -= 5
    pdf = table_data[:footer].call(pdf, @current_page_number, *table_data[:footer_args]) if table_data[:footer]
    pdf.start_new_page
    @current_page_number += 1
    pdf = table_data[:header].call(pdf, *table_data[:header_args]) if table_data[:header]
    pdf.stroke_color! color
    pdf.fill_color! fill_color
#    pdf.line(init_pos, pdf.y, right_edge, pdf.y).stroke if (show_lines == :all || show_lines == :borders)
    top_of_table = pdf.y
    pdf    
  end
  
  def generate_equal_columns(pdf, number)
    number = 1 if number == 0
    col_width = (pdf.absolute_right_margin - pdf.absolute_left_margin) / number
    columns = []
    (1..number).each { |n| columns.push(col_width * n) }
    return columns
  end
  
end