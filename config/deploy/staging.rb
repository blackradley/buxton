# =============================================================================
# STAGING SPECIFIC VARIABLES
# =============================================================================
set :domain, "impactstaging.org.uk"
set :rails_env, "staging"

# =============================================================================
# THIS WOULD BE IN DEPLOY.RB IF IT COULD BE LAZY EVALUATED, BUT IT CAN'T
# SO IT MUST GO HERE :/ MAKE SURE STAGING.RB AND PRODUCTION.RB ARE THE SAME
# =============================================================================
role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :deploy_to, "/home/deploy/public_html/#{domain}"