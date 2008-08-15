require 'RMagick'
include Magick

module BannerGeneration

  def create_organisation_banner(org_name, org_id)
    banner = ImageList.new(File.join('components','banner.png'))
    banner = banner.flatten_images

    gc = Draw.new
    gc.font= "Arial"
    gc.stroke = 'transparent'
    gc.pointsize = 14
    gc.fill = '#ffffff'
    gc.font_weight = NormalWeight
    gc.font_style = NormalStyle
    gc.gravity = NorthGravity
    gc.text_antialias = true
    metrics = gc.get_type_metrics(org_name)

    gc.annotate(banner, metrics.width,metrics.height,117,83, org_name)

    gc = Draw.new
    gc.font = File.join('components','Arial_Rounded_Bold.ttf')
    gc.stroke = 'transparent'
    gc.fill = '#63b8c1'
    gc.font_weight = BolderWeight
    gc.font_style = NormalStyle
    gc.pointsize = 14
    gc.gravity = NorthGravity
    gc.text_antialias = true
    metrics_2 = gc.get_type_metrics("Version 1.0")
  
    gc.annotate(banner, metrics_2.width,metrics_2.height,117+5+metrics.width,83, "Version 1.0")
  
    banner.write(File.join('public','images','organisations',"#{org_id}.png"))
  end

end