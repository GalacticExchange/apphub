class AddLogoToContainers < ActiveRecord::Migration[5.0]
  def change
    change_table :containers do |t|
      t.attachment :logo
    end
  end
end
