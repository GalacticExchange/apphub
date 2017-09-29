class SearchController < ApplicationController

  #rescue_from Mysql2::Error, with: :mysql_rescue

  layout 'search'

  def new

  end


  def index
    tmp = params[:order_by]
    @search = Search.new(options_param) if @search.nil?
    params[:order_by] = tmp
    @store_applications = @search.search_apps.paginate(page: params[:page])

  end

  def mysql_rescue
    @apps = []
  end

  private
    def options_param
      params[:order_by] = "#{params[:order_by]} #{params[:order_by_way]}"
      params.permit(
        :name,
        :min_size,
        :max_size,
        :min_ram,
        :max_ram,
        :order_by,
        :status => [],
        :application_type => [],
        :source_type => [],
        :security_rating => [],
        :os => []
      )
    end



end
