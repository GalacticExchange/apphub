# This migration comes from optimacms (originally 20150610222026)
class ChangeMetaDescriptionForPages < ActiveRecord::Migration
  def up
    change_table :cms_pages_translation do |t|
      t.change :meta_description, :text
    end
  end

  def down
    change_table :cms_pages_translation do |t|
      t.change :meta_description, :string
    end
  end
end
