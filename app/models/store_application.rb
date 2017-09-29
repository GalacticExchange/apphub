# == Schema Information
#
# Table name: store_applications
#
#  id                       :integer          not null, primary key
#  github_user              :string(255)
#  repo                     :string(255)
#  url_path                 :string(255)
#  name                     :string(255)
#  short_description        :string(255)
#  clair_rating             :integer          default("0")
#  source_type              :integer
#  application_type         :integer
#  status                   :integer          default("0")
#  size                     :float(24)
#  ram                      :float(24)
#  services_json            :text(65535)
#  readme_file_file_name    :string(255)
#  readme_file_content_type :string(255)
#  readme_file_file_size    :integer
#  readme_file_updated_at   :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class StoreApplication < ApplicationRecord
  include Randomable
  include ToHash

  validates_presence_of :github_user, :name, :url_path, :application_type, :status, :source_type

  scope :w_active, ->  {where(status: [1, 2])}
  scope :containers, ->  {where(application_type: 0)}
  scope :compose_apps, ->  {where(application_type: 1)}

  has_one :container, :dependent => :destroy
  has_one :compose_app, :dependent => :destroy
  accepts_nested_attributes_for :container
  accepts_nested_attributes_for :compose_app

  has_attached_file :readme_file
  do_not_validate_attachment_file_type :readme_file

  has_paper_trail

  self.per_page = 5

  enum source_type: [:github, :community, :official]
  enum clair_rating: [:unknown, :low, :medium, :high]
  enum application_type: [:container, :compose_app]
  enum status: [:inactive, :active, :tty_only]

  DEFAULT_ORDER_BY_VALUE = 'name ASC'
  #This the list of all accepted fields and methods you can request in fields[] param in API
  FIELDS = [:id, :ram, :github_user, :repo, :url_path, :launch_options, :version_hash,
            :readme, :clair_rating, :name, :status, :report_logs_link, :application_type, :gex_containers,
            :size, :source_type, :short_description, :link_to_self, :services, :github_link]


  #Get the containers with included dependencies and order them
  def self.get_with_includes( order_by )
    order_by = DEFAULT_ORDER_BY_VALUE.clone if order_by.blank?
    StoreApplication.includes(:container, :compose_app).order(order_by)
  end

  #Methods just for a convenient use

  def report_logs_link
    "#{Rails.application.config.download_url}container_logs/#{self.id}.tar.gz"
  end

  def link_to_self(url)
    "#{url}/#{self.github_user}/#{self.url_path}"
  end

  def readme
    self.readme_file_file_name.nil? ?
        nil :
        Paperclip.io_adapters.for(self.readme_file).read.encode(
            'UTF-8', :undef => :replace, :invalid => :replace, :replace => '')
  end

  def services
    JSON.parse(self.services_json.nil? ? '{}' : self.services_json, {:symbolize_names => true})
  end

  def gex_containers
    JSON.parse(self.containers_json.nil? ? '{}' : self.containers_json, {:symbolize_names => true})
  end

  def github_link
    "https://github.com/#{github_user}/#{repo}"
  end

  #-------------------

  #Methods for convenient convertion to hash

  def to_hash_for_list(url)
    {
        id: id,
        status: status,
        link: link_to_self(url)
    }
  end

  def to_hash_min
    {
        id: id,
        application_type: application_type,
        name: name,
        size: size,
        ram: ram,
        clair_rating: clair_rating,
        os_whole_name: container.nil? ? nil : container.os_whole_name,
    }
  end


  def method_missing(sym, *args, &block)
    case application_type
      when 'container'
        if Container::FIELDS.include? sym
          container.public_send(sym)
        else
          begin
            super
          rescue NoMethodError
            ''
          end
        end
      when 'compose_app'
        if ComposeApp::FIELDS.include? sym
          compose_app.public_send(sym)
        else
          begin
            super
          rescue NoMethodError
            ''
          end
        end
    end
  end

  def self.permit_fields(fields)
    response = fields.clone.select{ |x| FIELDS.include? x}
    response << Container.permit_fields(fields.clone)
    response << ComposeApp.permit_fields(fields.clone)
    response
  end

  def app_info
    {
      name: name,
      build_type: application_type.gsub('_app',''),
      type_info:{
        version_hash: version_hash,
        github_link: github_link
      },
      source:{
          type: 'apphub',
          github_user: github_user,
          url_path: url_path
      },
      metrics: {
        ram: ram,
        disk: size
      }
    }
  end

  def gex_hash
    {"ERROR" => "DEPRECATED METHOD"}
  end

  #----------------------------------

  #Params permitted for creation of the application

  def self.permit_params(params)
    params.permit(
              :id,
              :name,
              :github_user,
              :url_path,
              :repo,
              :readme_file,
              :status,
              :source_type,
              :short_description,
              :services_json,
              :containers_json,
              :ram,
              :version_hash,
              :size,
              :clair_rating,
              :application_type,
              container_attributes: [
                  :launch_options,
                  :metadata_json,
                  :file_name,
                  :dockerfile,
                  :os_whole_name,
                  :os_short_name,
                  :report_file
              ],
              compose_app_attributes: [
                  :compose_file,
                  :dockerfiles_json,
                  :metadata_json,
                  :clair_report
              ]
    )
    end

  def self.permit_update_params(params)
    params.permit(
        :name,
        :readme_file,
        :status,
        :short_description,
        :services_json,
        :ram,
        :version_hash,
        :size,
        :clair_rating,
        :containers_json
    )
  end

end