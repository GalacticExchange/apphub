module StoreApplicationHelper

  def docker_fiddle_link(application,service_name=nil,type='dockerfile')
    string = "http://docker-fiddle.galacticexchange.io/apphub?github_user=#{application.github_user}&url_path=#{application.url_path}&type=#{type}"
    string << "&service_name=#{service_name}" unless service_name.nil?
    string
  end

  def vul_class(type)
    case type
      when 'critical'
        'vul-cr'
      when 'high'
        'vul-hg'
      when 'medium'
        'vul-md'
      when 'low'
        'vul-lw'
      when 'negligible'
        'vul-ng'
      else
        'vul-un'
    end
  end


  def download_button(app)
    capture_haml do
      haml_tag :a ,role: 'button', href: "#{app.download_link}", style: 'margin-bottom: 10px;' do
        haml_tag :button, class:'btn_new_big mdl-js-button gex-btn-new' do
          haml_concat 'Download the container image'
        end
      end
    end
  end

  def operating_system
    haml_tag :p, class: 'marg_top_10'
      haml_concat 'Operating System:'
      yield
  end

  def admin_buttons(app)
    if Rails.env.development?
      capture_haml do
        link_to 'Edit', "/store_application/#{app.id}/edit?token=#{Rails.application.secrets.secret_token}", method: :get
        button_to 'Delete', "/store_application/#{app.id}?token=#{Rails.application.secrets.secret_token}", method: :delete
      end
    end
  end

end
