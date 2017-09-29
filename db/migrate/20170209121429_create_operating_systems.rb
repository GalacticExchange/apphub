class CreateOperatingSystems < ActiveRecord::Migration[5.0]
  def change
    create_table :operating_systems, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci' do |t|
      t.belongs_to :container, index: true
      t.integer :short_name, limit: 1
      t.string :whole_name
      # t.string :kernel_version

      t.timestamps
    end

    remove_column :containers, :operating_system, :string
  end
end
