class AddContainersJsonToStoreApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :store_applications, :containers_json, :text
    remove_column :compose_apps, :compose_erb
  end
end
