# This migration comes from optimacms (originally 20150610225422)
class AddIndexNameToPages < ActiveRecord::Migration

  def up
    add_index :cms_pages, :name

  end

  def down
    remove_index :cms_pages, :name
  end
end
