# require 'github_accessor'
# require 'report_getter'

namespace :fix_containers do

  desc "Fix containers size"
  task fix_size: :environment do
    Container.where(source_type: :official).each do |container|
      tmp = Helpers::SizeGetter.get_size(container.download_link)
      puts "#{container.id}, #{tmp}"
      container.update(:size => tmp)
      container.save
    end
  end

  desc "Fix containers launch_options"
  task fix_launch_options: :environment do
    Container.where(source_type: :official).each do |container|
      next if container.dockerfile.nil?
      parser = Helpers::DockerfileParser.new(lines: container.dockerfile.split("\n"))
      parser.start
      json = parser.to_json
      options = parser.make_code
      container.update(launch_options: options)
      container.update(raw_launch_options: json)
      container.save
    end
  end

  require 'json'

  desc "Add services field to raw_launch_options"
  task add_services: :environment do
    Container.all.each do |container|
      metadata = container.metadata
      services = {}

      puts metadata
      next if metadata.nil? || metadata['expose'].nil?

      metadata['expose'].each_with_index do |port, i|
        name = "#{container.name}-#{i}"
        protocol = (port == '80' || port == 80 || port == 8080 || port == '8080') ? 'http' : ''
        services[name] = {name: name, title: name.capitalize, protocol: protocol, port: port}
      end
      puts services
      container.update(services_json: services.to_json)

    end
  end
end
