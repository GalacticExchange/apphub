class AddSourceTypeToSearch < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :source_type, :string
  end
end
