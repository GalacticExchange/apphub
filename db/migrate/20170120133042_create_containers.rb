class CreateContainers < ActiveRecord::Migration[5.0]
  def change
    create_table :containers, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci' do |t|
      t.string :github_user
      t.string :repo
      t.string :url_path
      t.text :launch_options, :default => nil
      t.text :raw_launch_options, :default => nil
      t.string :file_name
      t.text :clair_report, :default => nil, :limit => 2147483647
      t.text :readme, :default => nil, :limit => 2147483647
      t.string :security_rating, :default => 'None'
      t.string :download_link
      t.string :name
      t.text :dockerfile
      t.text :image_report, :default => nil, :limit => 2147483647

      t.timestamps
    end
  end
end
