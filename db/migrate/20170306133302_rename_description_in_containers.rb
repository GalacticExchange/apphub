class RenameDescriptionInContainers < ActiveRecord::Migration[5.0]
  def change
    rename_column :containers, :description, :short_description
  end
end
