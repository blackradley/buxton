class CorrectingOrganisationStrategies < ActiveRecord::Migration
  def self.up
    outdated_ids = [513042287, 513042288, 513042289, 513042290, 513042291]
    OrganisationStrategy.find(outdated_ids).each{|oi|
      puts "deleting Organisation Strategy #{oi.id}"
      oi.destroy
    }
    puts "Deleting activity strategies for outdated ids"
    outdated_ids.map{|id| ActivityStrategy.find_by(strategy_id: id)}.flatten.map(&:destroy)
    puts "Deleted AS for outdated ids"
    old_ids = [513041609, 513041610, 513041611, 513041612, 513041613, 513041614, 513041615, 513041616, 513041617, 513041618, 513041619, 513041620, 513041621, 513041622, 513041623, 513041624, 513041625]
    organisation_id = 14
    names = [["Manage resources effectively, flexibly and responsively", "So that we can become one of the best-run authorities in England"], ["Investing in our staff to build an organisation that is fit for its purpose", "We can all help to improve services"], ["Raising performance in our services for children, young people, families and adults", "To help people lead successful, positive lives."], ["Raising performance in our housing services", "Because everybody deserves a decent place to live"], ["Cleaner, greener and safer city - Your City, Your Birmingham", "Residents tell us that a cleaner, safer Birmingham is their priority"], ["Investing in regeneration", "To increase job and training opportunities for everyone and build prosperity"], ["Improving the city's transport and tackling congestion", "To help provide safer ways to travel and keep the city moving"], ["A fair and welcoming city", "To build a city where people get along well together"], ["Providing more effective education and leisure opportunities", "Because we want to help everybody to achieve their full potential"], ["Promoting Birmingham as a great international city", "To secure prosperity and the status Birmingham deserves at home and abroad"]]
    strategies = names.each_with_index do |details, index|
      name, description = details
      OrganisationStrategy.connection.execute("INSERT INTO strategies (id, organisation_id, name, description, type) VALUES (#{old_ids[index]}, 14, \"#{name}\", \"#{description}\", 'OrganisationStrategy')")
      puts "Creating #{OrganisationStrategy.find(old_ids[index]).inspect}"
    end
  end
end
