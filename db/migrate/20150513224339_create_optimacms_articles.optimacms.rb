# This migration comes from optimacms (originally 20150218104103)
class CreateOptimacmsArticles < ActiveRecord::Migration
  def change
    create_table :optimacms_articles do |t|
      t.string :title
      t.text :text

      t.timestamps null: false
    end
  end
end
