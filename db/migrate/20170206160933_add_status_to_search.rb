class AddStatusToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :status, :integer
  end
end
