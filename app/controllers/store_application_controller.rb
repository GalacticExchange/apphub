class StoreApplicationController < ApplicationController

  layout 'basic'

  before_action :require_token
  skip_before_action :require_token, only: [:show, :render_store_application]



  def new
    case params[:type]
      when 'container'
        @store_application = StoreApplication.new(application_type: :container)
        @store_application.build_container
        render 'new' and return
      when 'compose_app'
        @store_application = StoreApplication.new(application_type: :compose_app)
        @store_application.build_compose_app
        render 'new' and return
      else
      render 'type_choice' and return
    end
  end

  def create
    @store_application = StoreApplication.new(StoreApplication.permit_params(params.require(:store_application)))

    if @store_application.save
      redirect_to my_store_application_path_url(github_user: @store_application.github_user, url_path: @store_application.url_path)
    else
      render 'new'
    end

  end


  def show
    @store_application = StoreApplication.find(params[:id])
  end

  def render_store_application
    @store_application = StoreApplication.w_active.find_by(:github_user => params[:github_user],
                                                   :url_path => params[:url_path])
    unless @store_application.nil?
      render 'show'
    else
      render_error(404, ActionController::RoutingError.new('Not Found'))
    end
  end



  def edit
    @store_application = StoreApplication.find(params[:id])
  end



  def update
    @store_application = StoreApplication.find(params[:id])
    if @store_application.update!(StoreApplication.permit_params(params.require(:store_application)))
      redirect_to my_store_application_path_url(github_user: @store_application.github_user, url_path: @store_application.url_path)
    else
      render 'edit'
    end
  end



  def destroy
    @store_application = StoreApplication.find(params[:id])
    @store_application.destroy
  end



  private
  def require_token
    if Rails.env.production? and !Rails.application.secrets.secret_token.eql?(params[:token])
      render_error(403, ActionController::InvalidAuthenticityToken.new)
    end
  end

end
