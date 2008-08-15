include BannerGeneration

class GeneratingBanners < ActiveRecord::Migration

  def self.up      
    organisations= Organisation.find(:all)
    organisations.each do |org|
      create_organisation_banner(org.name, org.id)
      puts "#{org.name} banner generated!"
    end
    create_organisation_banner('Demo', 'demo')
  end

  def self.down
  end
  
end
