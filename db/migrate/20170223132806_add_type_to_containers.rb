class AddTypeToContainers < ActiveRecord::Migration[5.0]
  def change
    remove_column :containers, :readme
    remove_column :containers, :clair_report
    remove_column :containers, :old_security_rating

    add_column :containers, :source_type, :integer, default: 0
    add_column :containers, :description, :string
  end
end
