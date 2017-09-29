class HomeController < BaseController

  def index

  end

  def google_verif
    render 'textpages/google_verif', :layout => false
  end

  def site_map
    @links = Container.where(status: 1)
    render 'textpages/sitemap'
  end

  def robots
    render 'textpages/robots'
  end

  def faq
    render 'faq', layout: 'basic'
  end

end
