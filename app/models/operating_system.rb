# == Schema Information
#
# Table name: operating_systems
#
#  id           :integer          not null, primary key
#  container_id :integer
#  short_name   :integer
#  whole_name   :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class OperatingSystem < ApplicationRecord

  belongs_to :container
end
