namespace :stars do
  
  DB_CONFIG = YAML.load_file('config/database.yml')
  S3_CONFIG = YAML.load_file('config/amazon_s3.yml')
  APP_NAME = 'buxton'
  namespace :db do
    desc "Mysql database backups to Amazon S3"
    task :backup => :environment do
      begin
        require 'right_aws'
        puts "[#{Time.now.utc}] stars:db:backup started"
        name = "#{APP_NAME}-#{RAILS_ENV}-#{Time.now.strftime('%Y-%m-%d-%H%M%S')}.dump"
        
        command = "mysqldump -u #{DB_CONFIG[RAILS_ENV]["username"]} -p#{DB_CONFIG[RAILS_ENV]["password"] } -h #{DB_CONFIG[RAILS_ENV]['host']} -Q --add-drop-table --add-locks=FALSE --single-transaction #{DB_CONFIG[RAILS_ENV]["database"]} > tmp/#{name}"
        system command
        # db = ENV['DATABASE_URL'].match(/postgres:\/\/([^:]+):([^@]+)@([^\/]+)\/(.+)/)
        # system "PGPASSWORD=#{db[2]} pg_dump -Fc --username=#{db[1]} --host=#{db[3]} #{db[4]} > tmp/#{name}"
        s3 = RightAws::S3.new(S3_CONFIG[RAILS_ENV]['access_key_id'], S3_CONFIG[RAILS_ENV]['secret_access_key'])
        bucket = s3.bucket("#{APP_NAME}-db-backups", true, 'private')
        bucket.put(name, open("tmp/#{name}"))
        system "rm tmp/#{name}"
        puts "[#{Time.now.utc}] stars:db:backup complete"
      # rescue Exception => e
      #   require 'toadhopper'
      #   Toadhopper(ENV['hoptoad_key']).post!(e)
      end
    end
  end
end
