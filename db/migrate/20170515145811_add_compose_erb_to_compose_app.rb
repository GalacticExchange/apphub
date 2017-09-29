class AddComposeErbToComposeApp < ActiveRecord::Migration[5.0]
  def change
    add_column :compose_apps, :compose_erb, :text, limit: 2000
  end
end
