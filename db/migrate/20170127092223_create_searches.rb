class CreateSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :searches, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci' do |t|
      t.string :name
      t.text :os
      t.decimal :min_size
      t.decimal :max_size
      t.decimal :min_ram
      t.decimal :max_ram
      t.string :security_rating

      t.timestamps
    end
  end
end
