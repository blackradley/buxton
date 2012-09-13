# =============================================================================
# PREVIEW SPECIFIC VARIABLES
#
# Preview is visible to the clients of Black Radley
#
# =============================================================================
set :domain, "preview.impactequality.co.uk"
set :rails_env, "preview"
set :port, 13427

set :rake, 'rake'
# =============================================================================
# THIS WOULD BE IN DEPLOY.RB IF IT COULD BE LAZY EVALUATED, BUT IT CAN'T
# SO IT MUST GO HERE :/ MAKE SURE STAGING.RB AND PRODUCTION.RB ARE THE SAME
# =============================================================================
role :app, domain
role :web, domain
role :db,  domain, :primary => true
set :deploy_to, "/home/deploy/public_html/#{domain}"
set :use_sudo, false

ssh_options[:forward_agent] = true

set :branch, 'rails3'