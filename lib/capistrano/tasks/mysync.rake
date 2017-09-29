
namespace :mysync do
  task :setup do
    on roles(:app) do
      p = File.join(shared_path, '..', 'repo-data')
      git_repo_data = 'ssh://git@git.friendlydata.com:10022/friendlydata/kep-data.git'
      execute "mkdir -p #{p} && cd #{p} && git init && git remote add origin #{git_repo_data}" rescue true
    end
  end

  task :commit do
    on roles(:app) do
      p = File.join(shared_path, '..', 'repo-data')
      #rsync -Lavrt --exclude-from '../{{server}}/files/rsync_exclude_list.txt' -e 'ssh -p {{ansible_ssh_port | default(22)}}'  {{root_user}}@{{inventory_hostname | quote}}:{{remote_path | quote}} {{backup_dir | quote }}
      #rsync -Lavrt --exclude-from '../{{server}}/files/rsync_exclude_list.txt' {{root_user}}@{{inventory_hostname}}:{{remote_path}} {{backup_dir}}
      execute "rsync -Lavrt --exclude-from '#{release_path}/.rsync_ignore' #{release_path}/ #{p}"

      execute %Q(cd #{p} && git add . && git commit -m "1" && git push origin master)

      #execute "cd #{shared_path} && git push origin production-shared " rescue true
    end
  end

  ###
  task :upload_code do
    on roles(:app) do

      upload!("app/controllers/", "#{current_path}/app/", :recursive => true)
      #upload!("app/views/", "#{current_path}/app/", :recursive => true)
      upload!("app/helpers/", "#{current_path}/app/", :recursive => true)
      upload!("app/models/", "#{current_path}/app/", :recursive => true)
      upload!("lib/", "#{current_path}", :recursive => true)

      #
      Rake::Task["deploy:restart"].invoke

    end
  end

  task :upload_views do
    on roles(:app) do
      upload!("app/views/", "#{current_path}/app/", :recursive => true)
      #
      Rake::Task["deploy:restart"].invoke

    end
  end


=begin
    task :update_server do
      on roles(:app) do
        execute "cd #{shared_path} && git pull origin production-shared " rescue true
      end
    end


    task :pull do
      on roles(:app) do
        #call cap production mysync:commit_server_shared

        #call cd ../site_production_shared

        #call git checkout production-shared
        #call git pull origin production-shared

        #execute "cd #{shared_path} && git pull origin production-shared " rescue true
      end
    end

=end

end

=begin
namespace :mysync do
  namespace :shared do
    task :commit_server do
      on roles(:app) do
        execute "cd #{shared_path} && git add -A . && git commit -m \"server changes \" " rescue true
        execute "cd #{shared_path} && git push origin production-shared " rescue true
      end
    end
    task :update_server do
      on roles(:app) do
        execute "cd #{shared_path} && git pull origin production-shared " rescue true
      end
    end


    task :pull do
      on roles(:app) do
        #call cap production mysync:commit_server_shared

        #call cd ../site_production_shared

        #call git checkout production-shared
        #call git pull origin production-shared

        #execute "cd #{shared_path} && git pull origin production-shared " rescue true
      end
    end

  end




end
=end