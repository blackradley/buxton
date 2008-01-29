# =============================================================================
# PRODUCTION SPECIFIC VARIABLES
# =============================================================================
set :domain, "impactengine.org.uk"

# =============================================================================
# THIS WOULD BE IN DEPLOY.RB IF IT COULD BE LAZY EVALUATED, BUT IT CAN'T
# SO IT MUST GO HERE :/
# =============================================================================
role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :deploy_to, "/var/www/vhosts/#{domain}/rails/testapp"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml" # required really but needs to be after deploy_to