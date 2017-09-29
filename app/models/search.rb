# == Schema Information
#
# Table name: searches
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  os               :text(65535)
#  min_size         :decimal(10, )
#  max_size         :decimal(10, )
#  min_ram          :decimal(10, )
#  max_ram          :decimal(10, )
#  security_rating  :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  github_user      :string(255)
#  order_by         :string(255)
#  status           :integer
#  source_type      :string(255)
#  application_type :string(255)
#

class Search < ApplicationRecord

  serialize :os, Array
  serialize :status, Array
  serialize :security_rating, Array
  serialize :source_type, Array
  serialize :application_type, Array

  def search_apps
    puts source_type
    if status.blank?
      apps = StoreApplication.w_active.get_with_includes(order_by)
    else
      apps = StoreApplication.get_with_includes(order_by)
      apps = apps.where(status: status)
    end
    apps = apps.where(application_type: application_type) if application_type.present? and !application_type.blank?
    puts application_type
    apps = apps.where(source_type: source_type) if source_type.present? and !source_type.blank?
    apps = apps.where(make_like_statement) if name.present? and !name.blank?
    apps = apps.where(['size <= ?', "#{max_size}"]) if max_size.present? and !max_size.blank?
    apps = apps.where(['size >= ?', "#{min_size}"]) if min_size.present? and !min_size.blank?
    apps = apps.where(['ram <= ?', "#{max_ram}"]) if max_ram.present? and !max_ram.blank?
    apps = apps.where(['ram >= ?', "#{min_ram}"]) if min_ram.present? and !min_ram.blank?
    # apps = apps.where(containers: {os_short_name: os}) if os.present? and !os.empty? #TODO  partially works, will require fixing
    apps = apps.where(clair_rating: security_rating) if security_rating.present? and !security_rating.blank?
    apps
  end

  def make_like_statement
    string = ''
    if name.include? ''
      name.gsub(/\s+/,' ')
      name.split(' ').each_with_index do |n, ind|
        string << "#{ ind == 0 ? '' : 'OR ' }name LIKE '%#{n}%' OR github_user LIKE '%#{n}%' OR short_description LIKE '%#{n}%'"
      end
    else
      string = "name LIKE '%#{name}%' OR github_user LIKE '%#{name}%' OR short_description LIKE '%#{name}%'"
    end
    string
  end


  def self.permit_params(params)
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
        :security_rating => []
    )

  end
end
