class ContainersController < ApplicationController

  layout 'basic'

  before_action :require_token
  skip_before_action :require_token, only: [:show, :render_container, :index]
  skip_before_action  :verify_authenticity_token, only: [:convert_old]



  def new
    @container = Container.new
  end

  def tmp
    @container = Container.find(1)
    render 'containers/_clair'
  end

  def create
    @container = Container.new(container_params_long(params))

    if @container.save
      redirect_to @container
    else
      render 'new'
    end
  end


  def convert_old
    json = request.body.read
    arguments = JSON.parse(json)
    arguments = ActionController::Parameters.new(arguments)
    @container = Container.new(Container.permit_params arguments)
    if @container.save
      head :ok
    else
      head :bad_request
    end

  end



  def show
    @container = Container.find(params[:id])
  end



  def render_container
    @container = StoreApplication.w_active.find_by(:github_user => params[:github_user],
                                   :url_path => params[:url_path])
    unless @container.nil?
      render 'show'
    else
      render_error(404, ActionController::RoutingError.new('Not Found'))
    end
  end



  def edit
    @container = Container.find(params[:id])
  end




  def update
    @container = Container.find(params[:id])
    if @container.update(container_params_long(params))
      redirect_to @container
    else
      render 'edit'
    end
  end



  def destroy
    @container = Container.find(params[:id])
    @container.destroy
  end



  private
    def require_token
      if Rails.env.production? and !Rails.application.secrets.secret_token.eql?(params[:token])
        render_error(403, ActionController::InvalidAuthenticityToken.new)
      end
    end



    def container_params_short
      params.require(:container).permit(:github_user, :repo, :url_path, :name)
    end


    def container_params_long args
      args.require(:container).permit(
          :github_user,
          :repo,
          :url_path,
          :launch_options,
          :file_name,
          :clair_report,
          :readme,
          :security_rating,
          :download_link,
          :name,
          :dockerfile,
          :status,
          :raw_launch_options
      )
    end

end
