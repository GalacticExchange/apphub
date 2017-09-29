class RemoveColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :containers, :download_link
    remove_column :searches, :fields

    change_column :containers, :dockerfile, :text
  end
end
