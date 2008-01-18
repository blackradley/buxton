#require "#{RAILS_ROOT}/config/initializers/migration_style_library_edits.rb"

class OrganisationPDFRenderer < Ruport::Renderer
  #Footer needs to be rendered first, as the activities appear as loose content objects too and will overwrite it if it 
  #is calculated after.
  stage :first_page, :footer, :page_numbers, :header, :activities_table, :progress_table, :results_table, :full_report, :renderer
end
class OrganisationPDF < Ruport::Formatter::PDF
  renders :pdf, :for => OrganisationPDFRenderer
  
  
  def build_first_page
    if data[10] then
      left = left_boundary()
      right = right_boundary
      pdf_writer.y = pdf_writer.absolute_y_middle + 128
      pdf_writer.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center)
      pdf_writer.add_text_wrap(left_boundary, pdf_writer.absolute_y_middle, right-left,  "<b>#{data[0]}</b>", 37, :center)
      3.times{add_text " "}
      pdf_writer.text "Impact Equality#{153.chr} Organisation Report", :justification => :center, :font_size => 19
      pdf_writer.start_new_page(true)
    end
  end
  
  def build_page_numbers
    pdf_writer.start_page_numbering(pdf_writer.absolute_left_margin,
      pdf_writer.absolute_bottom_margin - (pdf_writer.font_height(12) * 1.01) - 5,
      12,
      :left)
  end
  
  def build_header
    pdf_writer.fill_color Color::RGB.const_get('Black')
    pdf_writer.image( "#{RAILS_ROOT}/public/images/pdf_logo.png", :justification => :center, :resize => 0.6)
    pdf_writer.text "<b>#{data[0]}</b>", :justification => :center, :font_size => 19
    pdf_writer.text "Impact Equality#{153.chr} Organisation Summary Report", :justification => :center, :font_size => 12
    pdf_writer.text "" #Serves as a new line character. Is this more readable than moving the cursor manually?
    add_text " "
    add_text " "
  end
  
  def build_activities_table
    pdf_writer.text "<b>Activity Type</b>", :justification => :left
    add_text " "
    table = Table("Types", "Number")
    table << ["Existing Function", data[1]]
    table << ["Proposed Function", data[2]]
    table << ["Existing Policy", data[3]]
    table << ["Proposed Policy", data[4]]
    table << ["Unknown Type", data[5]]
    table << ["Total", data[6]]
    draw_table(table, :position=> :left, :orientation => 2)
    add_text " "
  end
  
  def build_progress_table
    add_text "<b>Progress</b>"
    add_text " "
    table = Table("", "Started", "Completed")
    data[7].each do |section, value|
      table << [section.to_s.titleize, value].flatten
    end
    draw_table(table, :position=> :left, :orientation => 2)
    add_text " "
  end
  
  def build_results_table
    add_text "<b>Results</b>"
    add_text " "
    table = Table("", "Low Impact", "Medium Impact", "High Impact")
    data[8].each do |priority_ranking, value|
      table << ["Priority #{priority_ranking}", value[:low], value[:medium], value[:high]]
    end
    draw_table(table, :position=> :left, :orientation => 2)
    add_text " "
    #pdf_writer.start_new_page if data[10]
  end
  
  def build_full_report
    if data[10] then
    directorate_page_count = []
      pdf_writer.set_proxy(nil)
      data[9].each do |directorate|
        directorate_page_count << [pdf_writer.pageset.index(pdf_writer.current_page) + 1, directorate]
        directorate.activities.each do |activity|
          pdf_writer.set_proxy([])
          data_for = activity.generate_pdf_data
          data_for[11] = [:unapproved_logo_on_first_page, :header, :body, :statistics, :issues]
          ActivityPDFGenerator.new(data_for)
	  #a.pdf.render_pdf
          separated = [[]]
          index = 0
          results = pdf_writer.get_proxy
          results.each do |result|
            unless result == :new_page then
              separated[index] << result
            else
              index += 1
              separated[index] = []
            end
          end
          separated.each do |page|
            pdf_writer.start_new_page
            pdf_writer.open_object do |page_object|
              page.each{|element| page_object << element}
              pdf_writer.close_object
              pdf_writer.add_object(page_object)
            end
          end
        end
      end
      pdf_writer.stop_page_numbering(true)
      pdf_writer.set_proxy(nil)
      directorate_page_count.each do |directorate_object|
        pdf_writer.directorate = directorate_object[1]
        opts = {
          :on       => true,
          :page     => directorate_object[0],
          :position => :before
        }
        pdf_writer.insert_mode(opts)
        pdf_writer.start_new_page
        pdf_writer.insert_mode(:off)
        pdf_writer.directorate
      end
    end
  end
  
  def build_footer
    pdf_writer.open_object do |footer|
      pdf_writer.save_state
      pdf_writer.stroke_color! Color::RGB::Black
      pdf_writer.stroke_style! pdf_writer.class::StrokeStyle::DEFAULT
      font_size = 12
      text = "Report Produced: #{Time.now.gmtime}"
      y = pdf_writer.absolute_bottom_margin - (pdf_writer.font_height(font_size) * 1.01) - 5
      width = pdf_writer.text_width(text, font_size)
      margin = pdf_writer.absolute_right_margin
      pdf_writer.add_text(margin - width, y, text, font_size)
      left_margin = pdf_writer.absolute_left_margin
      right_margin = pdf_writer.absolute_right_margin
      y = pdf_writer.absolute_bottom_margin - 5
      pdf_writer.line(left_margin, y, right_margin, y).stroke
      pdf_writer.restore_state
      pdf_writer.close_object
      pdf_writer.add_object(footer, :all_pages)
    end

  end
  def build_renderer
    pdf_writer.stop_page_numbering(true)
    render_pdf 
  end
end
