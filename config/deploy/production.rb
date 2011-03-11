# =============================================================================
# PRODUCTION SPECIFIC VARIABLES
# =============================================================================
set :domain, "impactengine.org.uk"
set :rails_env, "production"
set :port, 2020

set :rake, '/opt/ruby-enterprise-1.8.6-20090201/bin/rake'

# =============================================================================
# THIS WOULD BE IN DEPLOY.RB IF IT COULD BE LAZY EVALUATED, BUT IT CAN'T
# SO IT MUST GO HERE :/
# =============================================================================
role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :deploy_to, "/home/deploy/public_html/#{domain}"