


namespace :deploy do
  namespace :git do
    desc 'Upload from master branch to production branch and push to the remote'
    task :push do
      on roles(:app) do
        #system("git add -all")
        #system('call git commit -m "update"')

        system 'git checkout production'
        system 'git merge master'
        #rem call git reset --hard master
        system 'git checkout master'

        system 'git push origin production'

      end
    end

    task :commit_push do
      on roles(:app) do
        system("git add .")
        system('call git commit -m "update"')

        system 'git checkout production'
        system 'git merge master'
        #rem call git reset --hard master
        system 'git checkout master'

        system 'git push origin production'

      end
    end

  end
end

