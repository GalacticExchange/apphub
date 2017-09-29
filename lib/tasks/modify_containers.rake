namespace :modify_containers do

  desc 'Change old security_rating to new'
  task migrate_clair: :environment do
    FileUtils.mkdir_p Rails.root.join('public','system', 'clair_report')
    Container.all.each do |container|
      rating = container.old_security_rating
      case rating
        when 'High'
          rating = 3
        when 'Medium'
          rating = 2
        when 'Low'
          rating = 1
        when 'None'
          rating = 0
        else
          rating = 0
      end

      file_path = Rails.root.join('public','system', 'clair_report',"#{container.id}.txt")

      File.open(file_path, 'w') do |f|
        f.puts container.clair_report
      end

      file = File.open(file_path)
      container.create_security_rating(:rating => rating, :report => file)
      file.close
      container.save!


    end
    FileUtils.remove_dir Rails.root.join('public','system', 'clair_report'), true
  end

  desc 'Change readme from file_to attachment'
  task migrate_readme: :environment do
    FileUtils.mkdir_p Rails.root.join('public','system', 'readme')
    Container.all.each do |container|
      file_path = Rails.root.join('public','system', 'readme',"#{container.id}.txt")

      File.open(file_path, 'w') do |f|
        f.puts container.readme
      end

      file = File.open(file_path)
      container.readme_file = file
      file.close
      container.save!
      File.delete(file_path)
    end
    FileUtils.remove_dir Rails.root.join('public','system', 'readme'), true
  end

  desc 'Change readme from file_to attachment'
  task fix_short_name: :environment do
    NAMES = {
        'Debian' => 0,
        'Ubuntu' => 1,
        'CentOS' => 2,
        'Fedora' => 3,
        'Alpine' => 4,
        'Amazon' => 5,
        'Oracle' => 6,
        'openSUSE' => 7,
        'Kali' => 8
    }
    Container.all.each do |container|
      next if container.operating_system.nil?
      prefix = container.operating_system.whole_name.split(' ')[0]
      container.operating_system.update(short_name: NAMES[prefix])
      container.operating_system.save
    end

  end

  desc 'Change report from text file to JSON file'
  task report_convert: :environment do
    FileUtils.mkdir_p Rails.root.join('public','system', 'report_json')
    Container.w_active.each do |container|
      file_path = Rails.root.join('public','system', 'report_json',"#{container.id}.json")

      unless container.security_rating.nil?
        File.open(file_path, 'w') do |f|
          f.puts ClairReportConverter.convert(container.report_f)
        end

        file = File.open(file_path)

        container.security_rating.report_json = file

        file.close
        container.save!
        File.delete(file_path)
      end
    end
    FileUtils.remove_dir Rails.root.join('public','system', 'report_json'), true
  end

  desc 'Change container names for more convenient ones'
  task change_name: :environment do
    Container.all.each do |container|
      name = container.url_path.gsub('/',' - ')
      container.update(name: name.capitalize)
    end
  end

  desc 'Extract os from container names'
  task extract_os: :environment do
    Container.all.each do |container|
      next unless container.os_short_name.eql? 'unknown' or container.os_short_name.blank?
      puts container.name
      puts container.os_short_name
      if container.name.include? 'centos'
        container.create_operating_system(short_name: :centos, whole_name: 'CentOS Linux (Core)')
      end
      if container.name.include? 'centos7'
        container.create_operating_system(short_name: :centos, whole_name: 'CentOS Linux 7 (Core)')
      end
      if container.name.include? 'centos6'
        container.create_operating_system(short_name: :centos, whole_name: 'CentOS Linux 6 (Core)')
      end
      if container.name.include? 'ubuntu'
        container.create_operating_system(short_name: :ubuntu, whole_name: 'Ubuntu')
      end
      if container.name.include? 'redhat'
        container.create_operating_system(short_name: :ubuntu, whole_name: 'RedHat')
      end
      container.save!
      puts container.os_short_name
      puts
    end
  end

  desc 'Pull description from github'
  task description_pull: :environment do
    StoreApplication.all.each do |app|
      next if app.short_description or app.source_type.eql? 'official'
      begin
        repo = Helpers::GithubAccessor.get_repo("#{app.github_user}/#{app.repo}")
      rescue => e
        puts "#{app.github_user}/#{app.repo}  --- Error, could not get the description"
        puts e
        puts e.backtrace
      end
      app.short_description = repo['description'] unless repo.nil?
      app.save!
    end
  end



end