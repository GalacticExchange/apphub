
namespace :nginx do
  desc 'Create new server on Nginx'
  task :create_server do
    #on roles(:app), in: :sequence, wait: 1 do
    on roles(:app) do
      filename = 'config/database.yml'
      remote_path = '/opt/nginx/sites-available/temp.conf'
      #upload! filename, remote_path

      #run "#{sudo} apachectl restart"
      #execute :sudo, "cmd

      sudo "service nginx restart"


      #as "root" do
      #  #execute :something
      #  execute "service nginx restart"
      #end





    end
  end
end
