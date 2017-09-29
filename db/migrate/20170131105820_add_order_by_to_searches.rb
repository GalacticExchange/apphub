class AddOrderByToSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :searches, :order_by, :string
    add_column :searches, :fields, :string
  end
end
