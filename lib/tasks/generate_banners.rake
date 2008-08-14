namespace :images do
  desc "regenerate banners for all organisations"
  task :generateBanners => :environment do
    
    require 'rmagick'
    include Magick
    include BannerGeneration
        
    organisations= Organisation.find(:all)
    organisations.each do |org|
      create_organisation_banner(org.name, org.id)
      puts "#{org.name} banner generated!"
    end
    create_organisation_banner('Demo', 'demo')
    
  end  
end
