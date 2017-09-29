class AddVersionHashToStoreApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :store_applications, :version_hash, :string
  end
end
