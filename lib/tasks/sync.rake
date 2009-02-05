namespace :stars do
  
  PORT = 1417
  USER = 'buxton'
  HOST = 'impactengine.org.uk'
  R_ROOT = "rails/testapp"
  CURRENT = "#{R_ROOT}/current"
  SHARED = "#{R_ROOT}/shared"
  DB_CONFIG = YAML.load_file('config/database.yml')
  SHARED_FOLDERS = ['public/images/organisations']
  
  namespace :sync do    
    
    desc "Sync remote DB with local DB"
    task :db do
      puts "Dumping remote database..."
      puts "ssh -p #{PORT} #{USER}@#{HOST} \"mysqldump -u #{DB_CONFIG['production']["username"]} -p#{DB_CONFIG['production']["password"] } -h #{DB_CONFIG['production']['host']} -Q --add-drop-table --add-locks=FALSE --lock-tables=FALSE --ignore-table=#{DB_CONFIG['production']["database"]}.sessions #{DB_CONFIG['production']["database"]} > ~/dump.sql\""
      puts "Retrieving remote database..."
      puts "rsync -az -e \"ssh -p #{PORT}\" --progress #{USER}@#{HOST}:~/dump.sql ./db/production_data.sql"
      # 
      # mysql = if RUBY_PLATFORM.downcase.include?("darwin")
      #   "/Applications/MAMP/Library/bin/mysql"
      # elsif RUBY_PLATFORM.downcase.include?("linux")
      #   "mysql"
      # else
      #   raise "Unknown path to mysql for this platform."
      #   exit(1)
      # end
      # puts "Importing remote database..."
      # system "#{mysql} -u #{DB_CONFIG['development']["username"]} -p#{DB_CONFIG['development']["password"]} #{DB_CONFIG['development']["database"]} < ./db/production_data.sql"
      # # TODO: so I usually have a second step which updates the email addresses, blanks out any potentially sensitive data etc.
    end
    
    desc "Sync remote files with local files"
    task :files do
      SHARED_FOLDERS.each do |f|
        puts "Syncing #{f}..."        
        system "rsync -az -e \"ssh -p #{PORT}\" --progress #{USER}@#{HOST}:#{SHARED}/#{f}/ #{f}"
      end
    end
    
    desc "Sync remote DB and files with local DB and files"
    task :all => [:db, :files]
    
  end
  
end