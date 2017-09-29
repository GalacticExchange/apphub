class AddAttachmentToContainers < ActiveRecord::Migration[5.0]
  def up
    add_attachment :containers, :readme_file
  end

  def down
    remove_attachment :containers, :readme_file
  end
end
