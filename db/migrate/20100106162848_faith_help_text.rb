class FaithHelpText < ActiveRecord::Migration
  def self.up
    HelpText.all.each do |text|
      ['existing_function', 'existing_policy', 'proposed_function', 'proposed_policy'].each do |field|
        if text.send(field).match('faith')
          text.update_attribute(field, text.send(field).gsub('faiths', 'religions or beliefs').gsub('faith', 'religion or belief'))
          puts "#{text.id} updated"
        end
      end
    end
  end

  def self.down
    HelpText.all.each do |text|
      ['existing_function', 'existing_policy', 'proposed_function', 'proposed_policy'].each do |field|
        if text.send(field).match(/religions? or beliefs?/)
          text.update_attribute(field, text.send(field).gsub('religions or beliefs', 'faiths').gsub('religion or belief', 'faith'))
        end
      end
    end
  end
end
