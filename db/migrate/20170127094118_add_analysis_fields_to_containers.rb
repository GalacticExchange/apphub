class AddAnalysisFieldsToContainers < ActiveRecord::Migration[5.0]

  def up
    add_column :containers, :operating_system, :string
    add_column :containers, :size, :float
    add_column :containers, :ram, :float
    add_column :searches, :github_user, :string

  end

end
