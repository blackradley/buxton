require 'RMagick'

class GenerateController < ApplicationController

  def bar
    # Set up the variables
    percentage = params['id'].nil? ? 0 : params['id'].to_i
    width = params['width'].nil? ? 200 : params['width'].to_i 
    height = params['height'].nil? ? 10 : params['height'].to_i
    border_width = 1
    double_border_width = border_width * 2

    # Make an all-black image
    img = Magick::Image.new(width, height) do self.background_color = "black" end
    # Give it a white middle, paying attention to the border sizes - to give a border, in effect
    white = Magick::Image.new(width-double_border_width, height-double_border_width) do self.background_color = "white" end
    # Put the white bit on top of the black bit
    img.composite!(white, Magick::CenterGravity, Magick::OverCompositeOp)

    if percentage > 0 then
      # What does the percentage mean in terms of pixels?
      percentage_as_width = (percentage.to_f / 100) * (width-double_border_width)
  
      stripes = Magick::ImageList.new
      # Generate top gradient
      top_grad = Magick::GradientFill.new(0, 0, percentage_as_width, 0, "#dddddd", "#888888")
      stripes << Magick::Image.new(percentage_as_width, (height-double_border_width)/2, top_grad)
      # Generate bottom gradient
      bottom_grad = Magick::GradientFill.new(0, 0, percentage_as_width, 0, "#757575", "#555555")
      stripes << Magick::Image.new(percentage_as_width, (height-double_border_width)/2, bottom_grad)
      # Combine them on top of eachother
      combined_grad = stripes.append(true)
      # Make a solid block of colour which we will colourize the progress bar with
      colour = Magick::Image.new(combined_grad.columns, combined_grad.rows) do self.background_color = "yellow" end
      # Colourize it! and make the bar!
      bar = combined_grad.composite(colour, Magick::CenterGravity, Magick::ColorizeCompositeOp)
      # Put the bar on top of it all
      img.composite!(bar, border_width, border_width, Magick::OverCompositeOp)
    end

    # Send it to the browser
    img.format = "GIF"
    img_content = img.to_blob
    render :text => img_content, :status => 200, :content_type => 'image/gif'
  end

end