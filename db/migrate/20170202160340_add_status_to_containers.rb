class AddStatusToContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :status, :integer
  end
end
