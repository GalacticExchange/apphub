class SimplifyContainers < ActiveRecord::Migration[5.0]
  def change
    add_column :containers, :os_whole_name, :string
    add_column :containers, :os_short_name, :integer

    add_attachment :containers, :report_file
  end
end
