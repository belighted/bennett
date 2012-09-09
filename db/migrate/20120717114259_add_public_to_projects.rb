class AddPublicToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :public, :boolean, default: false
  end
end
