
namespace :my_server_setup do
  desc 'Setup server'
  task :init_shared_folder do
    on roles(:app) do
      app_path = fetch(:deploy_to)

      puts app_path
      # create shared dir
      path = File.join app_path, 'shared'
      execute "mkdir -p #{path}"

      # init
      execute "cd #{path} && git init && git checkout -b production-shared" rescue nil
      execute "cd #{path} && git remote add origin #{fetch(:repo_url)}"


    end
  end
end
