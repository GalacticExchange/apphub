# == Schema Information
#
# Table name: security_ratings
#
#  id                       :integer          not null, primary key
#  rating                   :integer
#  report_file_name         :string(255)
#  report_content_type      :string(255)
#  report_file_size         :integer
#  report_updated_at        :datetime
#  container_id             :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  report_json_file_name    :string(255)
#  report_json_content_type :string(255)
#  report_json_file_size    :integer
#  report_json_updated_at   :datetime
#

class SecurityRating < ApplicationRecord
  belongs_to :container
  enum rating: [:unknown, :low, :medium, :high]

  has_attached_file :report
  has_attached_file :report_json
  do_not_validate_attachment_file_type :report
  do_not_validate_attachment_file_type :report_json
end
