require 'csv'

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
  
  namespace :extract do
    task :helptext => :environment do
      def requires_strand?( name, number )
        list = Activity.question_setup_names[ name.to_sym ]
        result = []
        list.each do |key, val|
          if val.include? number
            result.push( key.to_s )
          end
        end
        return result
      end
      data = File.open(Rails.root + "config/questions.yml"){|yf| YAML::load( yf ) }
      result = []
      question_groups = data[ 'questions' ]
      overall_question_groups = data[ 'overall_questions' ]
      question_groups.each do |section_name, questions|
        questions.each do |number, fields|
          required_strands = requires_strand?( section_name, number )
          if required_strands.any?
            required_strands.each do |strand|
              result << [ section_name, strand, number, fields[ 'label' ], fields[ 'help' ] ]
            end
          else
            result << [ section_name, '', number, fields[ 'label' ], fields[ 'help' ] ]
          end
        end
      end
      overall_question_groups.each do |section_name, questions|
        questions.each do |number, fields|
          required_strands = requires_strand?( section_name, number )
          if required_strands.any?
            required_strands.each do |strand|
              result << [ section_name, strand, number, fields[ 'label' ], fields[ 'help' ] ]
            end
          else
            result << [ section_name, '', number, fields[ 'label' ], fields[ 'help' ] ]
          end
        end
      end
      result = result.sort{|x,y| "#{x[1]}_#{x[2]}" <=> "#{y[1]}_#{y[2]}"}
      CSV.open("doc/helptext.csv", "wb") do |csv|
        result.each do |row|
          if row[ 1 ].present?
            csv << [ "#{row[0]}_#{row[1]}_#{row[2]}", row[3], row[4] ]
          else
            csv << [ "#{row[0]}_#{row[2]}", row[3], row[4] ]
          end
        end
      end
    end
  end
  
end
