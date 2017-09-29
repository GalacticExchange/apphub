class CreateStoreApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :store_applications, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci'  do |t|
      t.string   :github_user
      t.string   :repo
      t.string   :url_path
      t.string   :name
      t.string   :short_description
      t.integer  :clair_rating,                             default: 0
      t.integer  :source_type
      t.integer  :application_type
      t.integer  :status,                                   default: 0
      t.float    :size,                   limit: 12
      t.float    :ram,                    limit: 12
      t.text     :services_json

      t.attachment :readme_file

      t.timestamps
    end

    add_reference :containers, :store_application, foreign_key: true

  end
end
