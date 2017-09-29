set :application, 'apphub_staging'
set :rails_env, 'staging'
set :gex_env, 'staging'
set :branch, 'application'
set :repo_url, 'ssh://git@gex1.devgex.net:5522/gex/apphub.git'


set :default_shell, '/bin/bash -l'

set :ssh_options, { forward_agent: true, paranoid: false,  user: 'deploy', password: 'deploy'}

server_ip = '35.166.222.201'

role :app, [server_ip]
role :web, [server_ip]
role :db,  [server_ip]

set :use_sudo, false
set :deploy_to, "/var/www/apps/#{fetch(:application)}"