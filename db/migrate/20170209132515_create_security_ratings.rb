class CreateSecurityRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :security_ratings, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci'  do |t|
      t.integer :rating, limit: 1
      t.attachment :report
      t.references :container, foreign_key: true

      t.timestamps
    end

    rename_column :containers, :security_rating, :old_security_rating
  end
end
