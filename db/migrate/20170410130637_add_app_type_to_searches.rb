class AddAppTypeToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :application_type, :string
    change_column :searches, :status, :string
  end
end
