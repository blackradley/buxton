namespace :images do
  desc "regenerate banners for all organisations"
  task :generate_banners => :environment do
    include BannerGeneration
    
    Organisation.find(:all).each do |org|
      create_organisation_banner(org.name, org.id)
      puts "#{org.name} banner generated!"
    end
    create_organisation_banner('Demo', 'demo')    
  end  
end