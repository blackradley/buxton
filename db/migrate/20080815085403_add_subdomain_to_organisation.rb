class AddSubdomainToOrganisation < ActiveRecord::Migration
  def self.up
    add_column :organisations, :subdomain, :string, {:default => 'www'}
    Organisation.find(:all).each do |o|
      puts "Setting #{o.name} subdomain to 'www'"
      o.update_attribute(:subdomain, 'www')
    end
  end

  def self.down
    remove_column :organisations, :subdomain
  end
end
