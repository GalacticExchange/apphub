source 'https://rubygems.org'

ruby "2.3.3"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

# Use Puma as the app server
gem 'puma', '~> 3.0'

#
gem 'mysql2'



#gem 'net-ssh', '3.1.1'
gem 'net-ssh', '3.1.1', :git => 'https://github.com/maxivak/net-ssh', :branch => '3-1-release'
#gem 'net-ssh', '4.0.0.alpha3'

#
gem 'devise', '4.2.0' #, '3.5.6'

if Bundler::WINDOWS
  #gem 'bcrypt-ruby', '~> 3.0.0', require: false
  gem 'bcrypt-ruby', '3.1.1.rc1', :require => 'bcrypt'
else
  gem 'bcrypt', '~> 3.1.10', require: false
end

#gem 'bcrypt', '~> 3.1.7'

#
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-linkedin'
#gem 'certified'

#
#gem 'activeadmin', '1.0.0.pre2'
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

#gem "activeadmin-sortable-tree"
gem "active_admin-sortable_tree"
#gem "activeadmin-sortable-tree", :github => "nebirhos/activeadmin-sortable-tree", :branch => "master"
#gem "activeadmin-sortable-tree", :github => "maxivak/activeadmin-sortable-tree", :branch => "master"


gem 'optimacms', '0.3.2', :git => 'https://github.com/maxivak/optimacms.git', :branch => 'rails5'
#gem 'optimacms', '0.3.2', path: '/projects/temp/optimacms'
#gem 'optimacms', '0.2.1', path: '../optimacms'
#gem 'optimacms', '0.2.1', :git => 'https://github.com/maxivak/optimacms.git', :branch => 'bootstrap_v4_alpha'

#gem 'rails_themes_bootstrap', '0.0.2',:git => 'git://github.com/maxivak/rails_themes_bootstrap.git'

gem 'globalize', '~>5.1.0', github: 'globalize/globalize'
gem 'activemodel-serializers-xml'
gem 'globalize-accessors'

#
gem 'haml-rails', '~>0.9.0'

#gem 'coffee-script-source'#, '1.8.0'
gem 'coffee-script-source', '1.8.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails' #,'4.0.3'
gem 'sass-rails', '~> 5.0'
gem 'compass-rails'#, '2.0.5'
gem 'sprockets-rails'#, '2.3.3'
gem 'uglifier', '>= 1.3.0'
gem 'font-awesome-rails'#, '4.3.0.0'
gem 'tether-rails'

# bootstrap
gem 'bootstrap-sass'#, '3.3.4.1'


# bootstrap v4 alpha
#gem 'jekyll', '~> 3.0.1'
#gem 'jekyll-redirect-from', '~> 0.9.0'
#gem 'jekyll-sitemap', '~> 0.9.0'
#gem 'sass', '>= 3.4.19'
#gem 'sass-rails', '4.0.3'
#gem 'scss_lint', '~> 0.43'


#gem 'bootstrap', '~> 4.0.0.alpha3'



#
gem 'rails-i18n'#, '4.0.8' # For 4.0.x

#
gem 'rack-cache'
gem 'redis-rails'



# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#gem 'turbolinks', '~> 5'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder' #, '~> 2.0'


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby


gem 'paperclip'#, '~> 4.2'
gem 'kaminari'
gem 'kaminari-bootstrap'#, '~> 3.0.1'

gem 'simple_form'
#gem 'simple_search_filter', '0.0.31'
gem 'simple_search_filter', '~>0.0.31', github: 'maxivak/simple_search_filter', branch: 'rails5'
gem 'bootstrap3_autocomplete_input', '0.2.0'


gem 'ancestry'
gem 'annotate'


# tinymce
gem 'tinymce-rails'#, '4.1.6'

# editor
gem 'el_finder', '1.1.12'


#
#gem 'callback_request_bootstrap'

#
gem 'redis'
gem "simple_events_redis", '1.0.1'
gem 'sidekiq'
gem 'octokit'
gem 'will_paginate'
gem 'will_paginate-bootstrap'

gem 'paper_trail'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end




group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  #gem 'web-console', '~> 2.0'

  gem 'rspec-rails'#, '3.1.0'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  #gem "capybara-webkit"
  #gem 'selenium-webdriver'
end


# deployment
group :development do
  gem 'capistrano'#,  '3.4.0'
  gem 'capistrano-rails'#, '1.1.3'
  gem 'capistrano-bundler'#, '~> 1.1'
  gem 'capistrano-rvm'#,   '~> 0.1'
  gem 'capistrano3-puma'
  gem 'pry'
  #gem 'capistrano-passenger'
  #gem 'capistrano-touch-linked-files'
  #gem 'capistrano-upload-config'

end
