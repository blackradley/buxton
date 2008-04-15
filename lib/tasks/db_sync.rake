require 'erb'

namespace :staging do
  desc "Getting a database dump off the staging server"
  task :sync do
    host = 'buxton@impactstaging.org.uk -p1417'
    path = '/var/www/vhosts/#{host}/rails/testapp'
    db_config = YAML::load(ERB.new(IO.read('config/database.yml')).result)
    system "ssh #{host} \"mysqldump -uadmin -pMineralWater buxton_staging > /tmp/dump.sql\""
    system "scp -P 1417 buxton@impactstaging.org.uk:/tmp/dump.sql ~/dump.sql"
    system "mysql -u #{db_config['development']["username"]} -p#{db_config['development']["password"]} #{db_config['development']["database"]} < ~/dump.sql"
  end
end