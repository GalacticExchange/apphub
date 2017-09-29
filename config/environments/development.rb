Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local       = true


  # cache
  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
        'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.action_view.cache_template_loading = false

    config.cache_store = :null_store
  end


  #config.action_controller.perform_caching = false
  #config.action_view.cache_template_loading = false

  # cache
  #config.cache_store = :redis_store, 'redis://localhost:6379/cms_tpl_dev/cache', { expires_in: (60*24*7).minutes }
  #config.cache_store = :redis_store, { :host => "localhost", :port => 6379, :db => 0, :namespace => "cms_tpl_dev", :expires_in => 90.minutes }

  #config.action_dispatch.rack_cache = {
  #    metastore:   'redis://localhost:6379/0/cms_tpl_dev',
  #    entitystore: 'redis://localhost:6379/0/cms_tpl_dev'
  #}


  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  #
  #config.serve_static_assets = true


  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
