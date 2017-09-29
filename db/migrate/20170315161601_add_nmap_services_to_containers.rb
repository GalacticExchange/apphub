class AddNmapServicesToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :nmap_services, :text, limit: 500
  end
end
