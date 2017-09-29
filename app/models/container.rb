# == Schema Information
#
# Table name: containers
#
#  id                       :integer          not null, primary key
#  github_user              :string(255)
#  repo                     :string(255)
#  url_path                 :string(255)
#  launch_options           :text(65535)
#  metadata_json            :text(65535)
#  file_name                :string(255)
#  name                     :string(255)
#  dockerfile               :text(65535)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  size                     :float(24)
#  ram                      :float(24)
#  status                   :integer
#  readme_file_file_name    :string(255)
#  readme_file_content_type :string(255)
#  readme_file_file_size    :integer
#  readme_file_updated_at   :datetime
#  source_type              :integer
#  short_description        :string(255)
#  nmap_services            :text(65535)
#  store_application_id     :integer
#  os_whole_name            :string(255)
#  os_short_name            :integer
#  report_file_file_name    :string(255)
#  report_file_content_type :string(255)
#  report_file_file_size    :integer
#  report_file_updated_at   :datetime
#

class Container < ApplicationRecord

  has_attached_file :report_file
  do_not_validate_attachment_file_type :report_file
  has_attached_file :readme_file
  do_not_validate_attachment_file_type :readme_file
  belongs_to :store_application
  has_and_belongs_to_many :compose_apps

  has_one :security_rating, :dependent => :destroy
  has_one :operating_system, :dependent => :destroy

  has_paper_trail

  enum os_short_name: [:debian, :ubuntu, :centos, :fedora, :alpine, :amazon_ami, :oracle, :opensuse, :kali]

  #This the list of all accepted fields and methods you can request in fields[] param in API
  FIELDS = [:download_link, :file_name, :os_short_name,
            :os_whole_name, :dockerfile, :metadata, :report_json]


  def download_link
    "#{Rails.application.config.download_url}#{self.store_application.github_user}/#{self.store_application.url_path}/#{self.file_name}"
  end

  def report_logs_link
    "#{Rails.application.config.download_url}container_logs/#{self.store_application.id}.tar.gz"
  end

  def link_to_self
    "#{Rails.application.config.SITE_URL}#{self.store_application.github_user}/#{self.store_application.url_path}"
  end

  def report_json
    JSON.parse(self.report_file_file_name.nil? ?
      '{}' :
      Paperclip.io_adapters.for(self.report_file).read.encode(
          'UTF-8', :undef => :replace, :invalid => :replace, :replace => ''))
  end

  def metadata
    JSON.parse(self.metadata_json.nil? ? '{}' : self.metadata_json, {:symbolize_names => true})
  end

  def self.permit_fields(fields)
    fields.select{ |x| FIELDS.include? x}
  end

  def self.permit_params(params)
    params.permit(
        :launch_options,
        :metadata_json,
        :file_name,
        :dockerfile,
        :os_whole_name,
        :os_short_name,
        :report_file
    )
  end

end
