namespace :huge_migrate do

  desc 'Migrate the containers to the new db structure'
  task migrate_containers: :environment do
    Container.all.each do |container|
      store_application = StoreApplication.new()
      store_application.id = container.id
      store_application.application_type = :container
      store_application.container = container
      store_application.clair_rating = container.security_rating.nil? ? :unknown : container.security_rating.rating
      store_application.github_user = container.github_user
      store_application.name = container.name
      store_application.repo = container.repo
      store_application.url_path = container.url_path
      store_application.readme_file = container.readme_file
      store_application.ram = container.ram
      store_application.size = container.size
      store_application.services_json = container.nmap_services
      store_application.status = container.status
      store_application.source_type = container.source_type
      if container.short_description
        store_application.short_description = container.short_description
      else
        begin
          repo = Helpers::GithubAccessor.get_repo("#{store_application.github_user}/#{store_application.repo}")
        rescue => e
          puts e
        end
        store_application.short_description = repo['description'] unless repo.nil?
      end
      begin
        store_application.save!
      rescue ActiveRecord::RecordInvalid => e
        puts e
        p store_application
        p container
      end

      store_application.reload.id
    end
  end

  desc 'Migrate the os and reports to containers themselves'
  task containers_change: :environment do
    Container.all.each do |container|
      # puts container.operating_system.whole_name
      container.update(os_whole_name: container.operating_system.whole_name) unless container.operating_system.nil?
      container.update(os_short_name: container.operating_system.short_name) unless container.operating_system.nil?

      container.report_file = container.security_rating.report_json unless container.security_rating.nil?
      container.save!
    end
  end

end