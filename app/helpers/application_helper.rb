module ApplicationHelper

  def link_page(pagename, args={})
    site_page_path(pagename, {lang: @lang}.merge(args))

  rescue => e
    nil
  end


end
