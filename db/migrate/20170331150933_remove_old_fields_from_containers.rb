class RemoveOldFieldsFromContainers < ActiveRecord::Migration[5.0]
  def change
    # add_column :store_applications, :sub_container_id, :integer
    #
    # remove_column :containers, :services_json
    # remove_column :containers, :image_report
    # remove_column :containers, :old_security_rating

    change_column :containers, :raw_launch_options, :text, limit: 1000
    change_column :containers, :launch_options, :text, limit: 1000
    remove_attachment :containers, :logo
  end
end
