set :application, "test_appname"
set :rails_env, 'beta'
set :branch, "production"

server 'myserver.com', user: 'myuser', roles: %w{web}, primary: true
set :deploy_to, "/var/www/apps/#{fetch(:application)}"


set :ssh_options, {
    forward_agent: true,
    user: 'myuser',
}


