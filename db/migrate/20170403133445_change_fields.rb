class ChangeFields < ActiveRecord::Migration[5.0]
  def change
    rename_column :containers, :raw_launch_options, :metadata_json

    #remove_column :store_applications, :sub_container_id

    create_table :compose_apps_containers, id: false do |t|
      t.integer :compose_app_id, index: true
      t.integer :container_id, index: true
    end

  end
end
