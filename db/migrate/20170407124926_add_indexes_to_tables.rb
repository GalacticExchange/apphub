class AddIndexesToTables < ActiveRecord::Migration[5.0]
  def change
    add_index :store_applications, [:github_user, :url_path], :unique => true

  end
end
