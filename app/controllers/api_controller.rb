class ApiController < ApplicationController
  require 'json'
  require 'pp'

  protect_from_forgery with: :null_session
  skip_before_action  :verify_authenticity_token

  #rescue_from Mysql2::Error, with: :mysql_rescue

  before_action :require_token, only: [:update_store_application, :create_store_application, :delete_store_application]
  #TODO What methods should I add?


  def index
    res = GexCore::Response.new
    res.set_data('{}')
    return_json(res)
  end

  def create_store_application
    res = GexCore::Response.new

    store_application = StoreApplication.new(StoreApplication.permit_params(params))

    if store_application.save
      res.set_data(success: 1, id: store_application.id)
    else
      res.set_error('500','Store Application wasn\'t saved')
      res.error_code = 500
      res.http_status = 500
    end
    return_json(res) and return
  end


  def update_store_application
    res = GexCore::Response.new

    unless params[:id]
      res.set_error_badinput('WRONG_PARAMS', 'id param must be present','')
      res.error_code = 400
      return_json(res) and return
    end

    store_application = StoreApplication.find(params[:id])
    if store_application.nil?
      res.set_error('NOT_FOUND','Could not find the store_application by given id')
      res.error_code = 404
      res.http_status = 404
      return_json(res) and return
    end

    store_application.update(StoreApplication.permit_update_params(params))

    if params['compose_app_attributes'].present? and store_application.compose_app.present?
      store_application.compose_app.update(ComposeApp.permit_params(params['compose_app_attributes']))
    end

    if params['container_attributes'].present? and store_application.container.present?
      store_application.container.update(Container.permit_params(params['container_attributes']))
    end

    if store_application.save
      res.set_data(success: 1)
    else
      res.set_error('500','Could not save changes')
    end
    return_json(res) and return
  end

  def random_store_application
    res = GexCore::Response.new
    store_application = StoreApplication.w_active.random
    if params[:fields].blank?
      res.set_data(store_application.to_hash_min)
    else
      fields = params[:fields].map { |x| x.to_sym}
      fields = store_application.permit_fields fields
      res.set_data(store_application.to_hash_with_fields(fields, request.base_url))
    end
    return_json(res)
  end

  def get_store_application
    res = GexCore::Response.new
    unless params[:id] or (params[:github_user] and params[:url_path])
      res.set_error_badinput('WRONG_PARAMS', 'id or github_user and url_path params must be present','')
      res.error_code = 400
      return_json(res) and return
    end

    if params[:id]
      store_application = StoreApplication.find_by(id: params[:id])
    else
      store_application = StoreApplication.find_by(github_user: params[:github_user], url_path: params[:url_path])
    end
    if store_application.nil?
      res.set_error('NOT_FOUND','Could not find the store application')
      res.error_code = 404
      res.http_status = 404
    else
      if params[:fields].blank?
        res.set_data(store_application.to_hash_min)
      else
        fields = params[:fields].map { |x| x.to_sym}
        fields = StoreApplication.permit_fields fields
        res.set_data(store_application.to_hash_with_fields(fields, request.base_url))
      end
    end

    return_json(res)
  end



  def list_store_applications
    res = GexCore::Response.new

    store_applications = StoreApplication.all
    res.set_data({
          total: store_applications.size,
          store_applications: store_applications.map(&:to_hash_for_list)
        }.to_json)
    return_json(res)
  end


  def search
    res = GexCore::Response.new

    if params[:fields].nil?
      res.set_error_badinput('WRONG_PARAMS', 'fields param must be present','')
      res.error_code = 400
      return_json(res) and return
    end

    if params[:fields].blank?
      res.set_error_badinput('WRONG_PARAMS', 'fields param must not be blank','')
      res.error_code = 400
      return_json(res) and return
    end
    fields = params[:fields].map { |x| x.to_sym }
    fields = StoreApplication.permit_fields fields.clone
    search_obj = Search.new(Search.permit_params(params))
    store_applications = search_obj.search_apps
    total = store_applications.size
    store_applications = store_applications.paginate(page: params[:page], per_page: params[:per_page] ? params[:per_page] % 50 : 10)

    return_hash = {
        store_applications: store_applications.map { |x| x.to_hash_with_fields(fields, request.base_url)},
        total: total
    }
    res.set_data(return_hash.to_json)
    return_json(res)
  end



  def delete_store_application
    res = GexCore::Response.new
    unless params[:id] or (params[:github_user] and params[:url_path])
      res.set_error_badinput('WRONG_PARAMS', 'id or github_user and url_path params must be present','')
      res.error_code = 400
      return_json(res) and return
    end

    if params[:id]
      store_application = StoreApplication.find_by(id: params[:id])
    else
      store_application = StoreApplication.find_by(github_user: params[:github_user], url_path: params[:url_path])
    end
    if store_application.nil?
      res.set_error('NOT_FOUND','Could not find the store application')
      res.error_code = 404
      res.http_status = 404
    else
      store_application.destroy
      res.set_data(success: 1)
    end
    return_json(res)
  end

  def app_meta
    app = StoreApplication.find_by(github_user: params[:github_user], url_path: params[:url_path]) or not_found
    compose = app.compose_app
    if compose.nil?
      res = GexCore::Response.new
      res.set_error('ERROR', 'this is not a docker-compose application','')
      res.error_code = 500
      return_json res and return
    end
    case params[:file_type]
      when 'metadata'
        old_file_name = "#{app.versions.length}_#{compose.versions.length}_metadata.rb"
        full_path = Rails.root.join('public','app_meta',app.github_user, app.url_path, old_file_name)

        unless File.file? full_path
          FileUtils.mkdir_p(Rails.root.join('public','app_meta',app.github_user, app.url_path))
          Dir.glob(Rails.root.join('public','app_meta',app.github_user, app.url_path, '*'))
                        .select{ |file| /metadata/.match file }.each { |file| File.delete(file)}
          begin
            generate_metadata_rb(app,full_path)
          rescue
            res = GexCore::Response.new
            res.set_error('METADATA_ERROR','Could not create metadata file')
            res.error_code = 500
            res.http_status = 500
          end
        end

        @document = File.read(full_path)
        send_data @document, filename: 'metadata.rb'
      else
        raise ActionController::RoutingError.new('No such file!')
    end
  end

  def mysql_rescue(exception)
    res = GexCore::Response.new
    res.set_error_exception('MySQL error',exception)
    return_json(res) and return
  end


  private

  def generate_metadata_rb(app, file_path)
    File.open(file_path,'w') do |f|
      f.puts "app_info = #{app.app_info.pretty_inspect}"
      f.puts "\n\n"
      f.puts 'app_info(app_info)'
      f.puts "\n\n"
      f.puts "attributes = #{app.metadata.pretty_inspect}"
      f.puts "\n\n"
      f.puts 'attributes(attributes)'
      f.puts "\n\n"
      f.puts "services = #{app.services.pretty_inspect}"
      f.puts "\n\n"
      f.puts 'services(services)'
      f.puts "containers = #{app.gex_containers.pretty_inspect}"
      f.puts "\n\n"
      f.puts 'containers(containers)'
    end
  end

  def verify_authenticity_token

  end


end