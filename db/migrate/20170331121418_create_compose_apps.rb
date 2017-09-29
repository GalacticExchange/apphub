class CreateComposeApps < ActiveRecord::Migration[5.0]
  def change
    create_table :compose_apps do |t|
      t.text :compose_file
      t.text :dockerfiles_json
      t.text :metadata_json, limit: 1000


      t.attachment :clair_report
      t.references :store_application

      t.timestamps
    end

    # add_reference :compose_apps, :store_application, foreign_key: true
  end
end
