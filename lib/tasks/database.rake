namespace :database do

  desc 'Update db to the latest version'

  task update: :environment do
    # Rake::Task['modify_containers:migrate_clair'].invoke
    # Rake::Task['fix_containers:fix_size'].invoke
    Rake::Task['fix_containers:fix_launch_options'].invoke
    # Rake::Task['modify_containers:migrate_readme'].invoke
  end

end
