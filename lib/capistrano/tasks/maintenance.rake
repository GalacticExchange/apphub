
# maintenance page
namespace :deploy do
  namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors.
        $ cap deploy:web:disable REASON="a hardware upgrade" UNTIL="12pm Central Time"
    DESC

    task :disable do
      on roles(:web) do
        execute "rm #{shared_path}/system/maintenance.html" rescue nil

        require 'haml'
        reason = ENV['REASON']
        deadline = ENV['UNTIL']
        template = File.read('app/views/textpages/maintenance.html.haml')
        #page = ERB.new(template).result(binding)
        engine = Haml::Engine.new(template)
        content = engine.render

        path = "public/system/maintenance.html"
        File.open(path, "w") { |f| f.write content }

        upload! path, "#{shared_path}/public/system/maintenance.html", :mode => 0644
      end

    end

    desc <<-DESC
      Get the site back up from maintenance
    DESC
    task :enable do
      on roles(:web) do
        # remove local
        path = "public/system/maintenance.html"
        File.delete(path)
        execute "rm #{shared_path}/public/system/maintenance.html"
      end
    end

  end
end