require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    config.secret_key = 'c8257e798bd69145dd45a49da0ab40d5ddd069a4bda24e137693b0c6c40329f06385eb39d0fa2c91ea52770b4db19a3501f4d4676da4b54b2c5783b4069d6e82'

    config.enable_dependency_loading = false
    config.eager_load_paths += %W( #{config.root}/lib )
    config.public_file_server.enabled = true
    #
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    #
    config.SITE_NAME = 'apphub'
    config.redis_prefix = 'apphub'
    config.SITE_URL = 'http://apphub.galacticexchange.io/'
    config.download_url = 'http://download.apphub.galacticexchange.io/'

  end
end
