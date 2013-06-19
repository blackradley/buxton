namespace :stars do
  
  PORT = 13427
  USER = 'deploy'
  HOST = {'production' => 'birmingham.impactequality.co.uk', 'staging' => 'staging.impactequality.co.uk'}
  R_ROOT = "public_html/#{HOST}"
  CURRENT = "#{R_ROOT}/current"
  SHARED = "#{R_ROOT}/shared"
  DB_CONFIG = YAML.load_file('config/database.yml')
  SHARED_FOLDERS = []
  CLIENT_DOMAINS = ['birmingham.gov.uk', 'servicebirmingham.co.uk']

  namespace :sync do    
    
    desc "Sync remote DB with local DB"
    task :db, [:src_env] => :environment do |t, args|
      args.with_defaults(:src_env => 'production')
      puts "Dumping remote database..."
      system "ssh -p #{PORT} #{USER}@#{HOST[args.src_env]} \"mysqldump -u #{DB_CONFIG[args.src_env]["username"]} -p#{DB_CONFIG[args.src_env]["password"] } -h #{DB_CONFIG[args.src_env]['host']} -Q --add-drop-table --add-locks=FALSE --lock-tables=FALSE #{DB_CONFIG[args.src_env]["database"]} > /tmp/dump.sql\""
      puts "Retrieving remote database..."
      system "rsync -az -e \"ssh -p #{PORT}\" --progress #{USER}@#{HOST[args.src_env]}:/tmp/dump.sql ./db/production_data.sql"
      
      puts "Importing remote database..."
      system "mysql -u #{DB_CONFIG['development']["username"]} -p#{DB_CONFIG['development']["password"]} #{DB_CONFIG['development']["database"]} < ./db/production_data.sql"
      
      # # TODO: so I usually have a second step which updates the email addresses, blanks out any potentially sensitive data etc.
      index = 1
      CLIENT_DOMAINS.each do |domain|
        new_domain = "example#{index}.example"
        puts "Resetting client email addresses for #{domain} to #{new_domain}"
        User.transaction do
          User.where("users.email LIKE ?", "%@#{domain}%").each do |u| 
            u.update_attribute( :email, (u.email.gsub(Regexp.new(domain), new_domain)) )
          end
        end
        index += 1
      end

    end
    
    desc "Sync remote files with local files"
    task :files, [:src_env] => :environment do |t, args|
      args.with_defaults(:src_env => 'production')
      SHARED_FOLDERS.each do |f|
        puts "Syncing #{f}..."        
        system "rsync -az -e \"ssh -p #{PORT}\" --progress #{USER}@#{HOST[args.src_env]}:#{SHARED}/#{f}/ #{f}"
      end
    end
    
    desc "Sync remote DB and files with local DB and files"
    task :all => [:db, :files]
    
  end
  
end