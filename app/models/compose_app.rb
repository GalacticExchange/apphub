# == Schema Information
#
# Table name: compose_apps
#
#  id                        :integer          not null, primary key
#  compose_file              :text(65535)
#  dockerfiles_json          :text(65535)
#  metadata_json             :text(65535)
#  clair_report_file_name    :string(255)
#  clair_report_content_type :string(255)
#  clair_report_file_size    :integer
#  clair_report_updated_at   :datetime
#  store_application_id      :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class ComposeApp < ApplicationRecord
  belongs_to :store_application
  has_and_belongs_to_many :containers

  has_attached_file :clair_report
  do_not_validate_attachment_file_type :clair_report

  has_paper_trail

  FIELDS = [:metadata, :compose_file, :dockerfiles, :report_json, :compose_erb]

  def dockerfiles
    JSON.parse(self.dockerfiles_json.nil? ? '{}' : self.dockerfiles_json)
  end

  def report_json
    JSON.parse(self.clair_report_file_name.nil? ?
                   '{}' :
                   Paperclip.io_adapters.for(self.clair_report).read.encode(
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
        :compose_file,
        :dockerfiles_json,
        :metadata_json,
        :clair_report
    )
  end

end
