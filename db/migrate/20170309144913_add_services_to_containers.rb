class AddServicesToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :services_json, :text, limit: 1000
  end
end
