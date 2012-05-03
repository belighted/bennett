class AddHookTokenToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :hook_token, :string

  end
end
